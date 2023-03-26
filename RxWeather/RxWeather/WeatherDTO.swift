//
//  WeatherDTO.swift
//  RxWeather
//
//  Created by 조주혁 on 2023/03/26.
//

import Foundation

struct WeatherDTO: Codable {
    let list: [List]?
    
    struct List: Codable {
        let main: Main?
        
        struct Main: Codable {
            let temp: Float?
        }
    }
}
