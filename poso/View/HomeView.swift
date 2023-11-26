//
//  HomeView.swift
//  poso
//
//  Created by 박희경 on 2023/11/18.
//

import SwiftUI
import CoreLocation


struct HomeView: View {
    @ObservedObject var carStore: CarStore
    @ObservedObject var weatherManager: WeatherManager 
    @ObservedObject var locationManager: LocationManager
    
    @State private var isModalPresented = true
    @State var weather: Weather?
    @State private var region: String = "침수 위험 높음"
    @State var rain: String = "40mm"
    @State var waterSensor: String = "80%"
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var markers: [CLLocationCoordinate2D] = []
    
    @State private var convertedMarkers: [LandmarkAnnotation] = []
    
    var body: some View {
        ZStack {
            MapView(carStore: carStore, locationManager: locationManager)
                .ignoresSafeArea(edges: .top)
            VStack {
                Spacer()
                VStack() {
                    VStack {
                        HStack{
                            Spacer()
                            Text("MyGenesis")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        Text("현재 차량 위치: 인천대학교 지하 1층 지하주차장 B-11")
                            .font(.caption)
                            .foregroundColor(.black)
                        Text("차량 번호: 331소 8967")
                            .font(.caption)
                            .foregroundColor(.black)
                    }.padding(.bottom, 20)
                    
                    Divider()
                        .padding(.bottom, 30)
                    
                    HStack {
                        HStack {
                            if let data = carStore.car, let weather = carStore.weather {
//                                HomeRow(title: "지역", description: "\(carStore.floodSafetyZoneStatus.rawValue)")
//                                    .padding(.trailing, 5)
                                HomeRow(title: "지역", description: "High")
                                    .padding(.trailing, 5)
                                VerticalDivider()
//                                HomeRow(title: "강수량", description: "\(weather.rain?.the1H ?? 0)mm")
//                                    .padding(.horizontal, 5)
                                HomeRow(title: "강수량", description: "250mm")
                                    .padding(.horizontal, 5)
                                VerticalDivider()
                                HomeRow(title: "물 감지 센서", description: data.waterValue)
                                    .padding(.leading, 5)
                                VerticalDivider()
                                HomeRow(title: "위험 단계", description: data.waterDetectionLevel)
                                    .padding(.leading, 5)
                            }
                            
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(25)
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }.onAppear {
            if let carData = carStore.car {
                locationManager.updateMarkerLocation(lat: Double(carData.latitude) ?? 0.0, long: Double(carData.logitude) ?? 0.0 )
            } else {
                print("carData 없음")
            }
        }
    }
    
}

enum type: String {
    case region
    case rain
    case sensor
    case level
}

struct HomeRow: View {
    var title: String
    var description: String
    
    var body: some View {
        HStack{
            VStack(alignment: .center) {
                Text(title)
                    .font(.callout)
                    .foregroundColor(Color.secondary)
                
                Text(description)
                    .font(.body)
                    .bold()
                    .foregroundColor(Color.black)
            }
        }
    }
}


struct VerticalDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 1, height: 20)
        
    }
}


