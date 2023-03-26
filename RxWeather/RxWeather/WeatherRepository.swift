//
//  WeatherRepository.swift
//  RxWeather
//
//  Created by 조주혁 on 2023/03/26.
//

import Foundation
import RxSwift
import Alamofire

protocol Repositoy {
    func getWeather() -> Observable<WeatherDTO>
}

class WeatherRepository: Repositoy {
    func getWeather() -> Observable<WeatherDTO> {
        print("getWeather Repository")
        let lat = "37.5665"
        let lon = "126.9780"
        let appId = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String ?? ""
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(appId)"
        print(appId)
        return Observable<WeatherDTO>.create { observer in
            AF.request(url, method: .get).responseDecodable(of: WeatherDTO.self) { response in
                switch response.result {
                case .success(let value):
                    print(value, "success")
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    print("fail", error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
