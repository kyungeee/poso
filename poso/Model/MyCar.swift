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
    
    var progressBarText: String {
        switch step {
        case "0":
            return "safe"
        case "1":
            return "warning⚠️"
        case "2" :
            return "danger🚨"
        default:
            return ""
            
        }
    }
    
    var progressBarState: Float {
        switch step {
        case "1":
            return 0.5
        case "2" :
            return 1.0
        default:
            return 0.0
        }
    }
    
}

extension MyCar {
    enum FloodingRiskLevel: String {
        case low = "safe"
        case moderate = "warning⚠️"
        case high = "danger🚨"
    }
    
}

