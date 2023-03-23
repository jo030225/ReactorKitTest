//
//  MainReactor.swift
//  ReactorKitTest
//
//  Created by 조주혁 on 2023/03/23.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

class MainReactor: Reactor {
    let initialState: State = State()
    
    // Action
    enum Action {
        case increase
        case decrease
    }
    
    // 처리 단위
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    // 현재 상태
    struct State {
        var value = 0
        var isLoading = false
    }
    
    // Action이 들어온 경우, 어떤 처리를 할건지 분기
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.increaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.decreaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        }
    }
    
    // 이전 상태와 처리 단위를 받아서 다음 상태를 반환
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let bool):
            newState.isLoading = bool
        }
        return newState
    }
}
