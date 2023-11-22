//
//  Location.swift
//  poso
//
//  Created by 박희경 on 2023/11/22.
//

import Foundation

struct LocationData: Codable {
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

//do {
//    let jsonData = jsonData.data(using: .utf8)!
//    let locations = try JSONDecoder().decode([LocationData].self, from: jsonData)
//    print(locations)
//} catch {
//    print("Error decoding JSON: \(error)")
//}

//{
// "objectid": 1,
// "no": "29",
// "번호": "29",
// "구명": "남구",
// "침수구": "용현동 고속도로 종점",
// "Latitude": 37.4517008,
// "Longitude": 126.6470943,
// "비고": "2012추가",
// "shape_Length": 1754.971755600548,
// "shape_Area": 117791.1303457599
//}
