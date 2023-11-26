//
//  Location.swift
//  poso
//
//  Created by 박희경 on 2023/11/22.
//

import Foundation

//MARK: - Location Model
struct Location: Codable {
    let objectId: Int
    let number: String
    let districtName: String
    let floodedArea: String
    let latitude: Double
    let longitude: Double
    let remarks: String
    let shapeLength: Double
    let shapeArea: Double

    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case number = "no"
        case districtName = "구명"
        case floodedArea = "침수구"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case remarks = "비고"
        case shapeLength = "shape_Length"
        case shapeArea = "shape_Area"
    }
}

//MARK: - 상습 침수 구역과 현재 차량 위치와의 거리에 따른 위험 수준 열거형 정의
enum DangerLevel: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}



