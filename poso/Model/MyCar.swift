//
//  MyCar.swift
//  poso
//
//  Created by 박희경 on 2023/11/17.
//

import Foundation

class MyCar: Decodable {
    let id: String
    let latitude: Double
    let logtitude: Double
    let waterSensorData: Double
    let detectionTime: Date
}
