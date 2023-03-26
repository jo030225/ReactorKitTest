//
//  WeatherReactor.swift
//  RxWeather
//
//  Created by 조주혁 on 2023/03/26.
//

import Foundation
import ReactorKit
import RxSwift

class WeatherReactor: Reactor {
    let useCase: WeatherUseCase
    let initialState: State = State()
    let disposeBag = DisposeBag()
    
    init(useCase: WeatherUseCase) {
        self.useCase = useCase
    }
    
    enum Action {
        case viewDidLoad
        case refresh
    }
    
    enum Mutation {
        case getWeather(String)
        case setLoading(Bool)
    }
    
    struct State {
        var temp: String = "-"
        var isLoading: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                useCase.getWeather().map{ Mutation.getWeather($0.temp) }.catch({ error in .just(Mutation.getWeather(error.localizedDescription)) }),
                Observable.just(.setLoading(false))
            ])
        case .refresh:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                useCase.getWeather().map{ Mutation.getWeather($0.temp) }.catch({ error in .just(Mutation.getWeather(error.localizedDescription)) }),
                Observable.just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getWeather(let temp):
            newState.temp = temp
        case .setLoading(let bool):
            newState.isLoading = bool
        }
        return newState
    }
}
