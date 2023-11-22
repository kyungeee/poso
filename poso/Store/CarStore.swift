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
    
}



