//
//  Float+.swift
//  RxWeather
//
//  Created by 조주혁 on 2023/03/26.
//

import Foundation

extension Float {
    func getTemp() -> String {
        return "\(Int(self) - 273)°"
    }
}
