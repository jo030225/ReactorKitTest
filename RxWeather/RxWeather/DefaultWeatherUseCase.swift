//
//  DefaultWeatherUseCase.swift
//  RxWeather
//
//  Created by 조주혁 on 2023/03/26.
//

import Foundation
import RxSwift

protocol WeatherUseCase {
    func getWeather() -> Observable<WeatherModel>
}

class DefaultWeatherUseCase: WeatherUseCase {
    
    let repository: Repositoy
    
    init(repository: Repositoy) {
        self.repository = repository
    }
    
    func getWeather() -> Observable<WeatherModel> {
        print("getWeather")
        return repository.getWeather()
            .map { ($0.list?.first?.main?.temp ?? 0).getTemp() }
            .map { WeatherModel(temp: $0) }
    }
}
