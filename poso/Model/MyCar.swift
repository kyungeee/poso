//
//  MyCar.swift
//  poso
//
//  Created by 박희경 on 2023/11/17.
//

import Foundation

// MARK: - MyCar Model
class MyCar: Decodable {
    let latitude: String
    let logitude: String
    let waterValue: String
    let date: String
    let time: String
    let step: String
    
    var waterDetectionLevel: String {
        switch step {
        case "0":
            return "safe"
        case "1":
            return "warning"
        case "2":
            return "danger"
        default:
            return "unknown"
        }
    }
}

extension MyCar {
    enum FloodingRiskLevel: String {
        case low = "안전"
        case moderate = "주의"
        case high = "위험"
    }
    
}

