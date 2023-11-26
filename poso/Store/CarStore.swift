//
//  CarViewModel.swift
//  poso
//
//  Created by 박희경 on 2023/11/19.
//

import Foundation
import FirebaseDatabase
import CoreLocation

final class CarStore: ObservableObject {
    @Published var car: MyCar?
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var markers: [CLLocationCoordinate2D] = []
    @Published var convertedMarkers: [LandmarkAnnotation] = []
    @Published var weather: Weather?
    @Published var highRiskZones: [Location] = []
    @Published var floodSafetyZoneStatus: DangerLevel = .low
    
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("id6")
        return ref
    }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func fetchInitialData() {
          guard let databasePath = databasePath else {
              return
          }

        // observeSingleEvent로 초기 데이터 가져오기
          databasePath.observeSingleEvent(of: .value) { [weak self] snapshot in
              guard let self = self,
                    let value = snapshot.value as? [String: Any] else {
                  return
              }
              
              do {
                  let carData = try JSONSerialization.data(withJSONObject: value)
                  let car = try self.decoder.decode(MyCar.self, from: carData)
                  self.car = car
                  updateMarkerLocation(lat: Double(car.latitude) ?? 0.0, long: Double(car.logitude) ?? 0.0)
              } catch {
                  print("Error decoding initial data:", error)
              }
          }
        
        // .childChanged 이벤트를 감지하여 데이터 업데이트 처리
        databasePath.observe(.childChanged) { [weak self] snapshot, _ in
            guard let self = self,
                  let value = snapshot.value as? [String: Any]
            else { return }
            
            print("값이 변경됨.")
            
            do {
                try self.processCarData(value)
                print("value: \(value)")
            } catch {
                print("Error decoding changed data:", error)
            }
        }
        
        
        // .childAdded 이벤트를 감지하여 새로운 데이터 처리
        databasePath.observe(.childAdded) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: Any]
            else { return }
            
            print("값이 추가됨.")
            
            do {
                try self.processCarData(value)
            } catch {
                print("Error decoding added data:", error)
            }
        }
        
    }
    
    func addNewCar() {
        Database.database().reference().child("id4").child("12341234").setValue([
            "latitude": "",
            "logitude": "",
            "waterValue": "",
            "date": "",
            "time": "",
            "step": ""
        ])
    }
    
    func stopListening() {
        databasePath?.removeAllObservers()
    }
    
}

extension CarStore {
    
    private func processCarData(_ data: [String: Any]) throws {
        guard let carData = try? JSONSerialization.data(withJSONObject: data) else {
            throw MyError.dataSerialization
        }
        
        let car = try decoder.decode(MyCar.self, from: carData)
        self.car = car
        updateMarkerLocation(lat: Double(car.latitude) ?? 0.0, long: Double(car.logitude) ?? 0.0)
        print("car: \(car)")
    }
    
    enum MyError: Error {
        case dataSerialization
    }
    
}

extension CarStore {
    func updateMarkerLocation(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
        self.markers = [CLLocationCoordinate2D(latitude: lat, longitude: long)]
        for cord in markers {
            let mark = LandmarkAnnotation(title: "MyCar", subtitle: "Sub", coordinate: cord)
            self.convertedMarkers = [mark]
        }
        
        // FIXME: - refector *
        Task {
            do {
                try await getCurrentWeather(
                    latitude: self.latitude,
                    longitude: self.longitude) // 현재 날씨 데이터 fetch
            } catch {
                print("NetorkError: \(error)")
            }
        }
    }
    
}


extension CarStore {
    
    // HTTP request to get the current weather depending on the coordinates we got from LocationManager
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws  {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=48532a5e16bd27acbb55cf0c9b778afc&units=metric") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        
        let decodedData = try JSONDecoder().decode(Weather.self, from: data)
        
        self.weather = decodedData
    }
    
    func loadAndDecodeJSON(from fileName: String) {
        guard let jsonData = loadJSONDataFromFile(named: fileName) else {
            print("Failed to load JSON data from file.")
            return
        }
        
        let result: Result<[Location], Error> = decodeJSONData(jsonData, modelType: [Location].self)
        
        switch result {
        case .success(let locations):
            highRiskZones = locations
        case .failure(let error):
            print("Error decoding JSON: \(error)")
        }
    }
    
    
    private func loadJSONDataFromFile(named fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("Error reading JSON file: \(error)")
            }
        }
        return nil
    }
    
    private func decodeJSONData<T: Decodable>(_ jsonData: Data, modelType: T.Type) -> Result<T, Error> {
        do {
            let decodedData = try JSONDecoder().decode(modelType, from: jsonData)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
    
}

extension CarStore {
    
    func assessDangerLevelBetweenNodes()  {
        // 거리 계산 및 위험 여부 판단 로직
        // DangerLevel은 열거형으로 정의하여 적절한 위험 수준을 표현합니다.
        // 예: .low, .medium, .high
        
        // 최초로 거리를 구하기 위해 초기값 설정
        var nearestDistance: CLLocationDistance = CLLocationDistance.infinity
        var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        for zone in highRiskZones {
            let zoneLocation = CLLocationCoordinate2D(latitude: zone.latitude, longitude: zone.longitude)
            let distance = calculateDistance(from: myLocation, to: zoneLocation)
            
            // 최소 거리 업데이트
            nearestDistance = min(nearestDistance, distance)
        }
        
        // DangerLevel 판단
        if nearestDistance < 10.0 {
            floodSafetyZoneStatus = .low
        } else if nearestDistance < 50.0 {
            floodSafetyZoneStatus = .medium
        } else {
            floodSafetyZoneStatus = .high
        }
        
    }
    
    // 두 좌표 간의 거리 계산
    private func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
    
}

