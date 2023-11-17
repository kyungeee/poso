//
//  ContentView.swift
//  POSO
//
//  Created by 박희경 on 2023/11/10.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    private var weatherManager = WeatherManager()
    @State private var tabViewSelectedIndex: Int = 0
    @State private var weather: ResponseBody?

    var body: some View {
        NavigationView {
            VStack {
//                if let weather = weather {
//                    MyPageView(weather: weather)
//                } // 테두리 스타일 추가
                
                NavigationStack {
                    VStack {
                        TabView(selection: $tabViewSelectedIndex) {
                            MapView()
                                .tabItem {Image(systemName: "car.fill")}
                                .tag(1)
                            if let weather = weather {
                                MyPageView(weather: weather)
                                    .tabItem { Image(systemName:  "drop.triangle" )}
                                    .tag(2)
                            }
                        }
                        .accentColor(.purple)
                        .onAppear {
                            UITabBar.appearance().backgroundColor = .black
                        }
                    }
                }
                
//                MapView()
            }.onAppear(perform: {
                Task {
                    do {
                        let latitude: CLLocationDegrees = 37.45154603029362
                        let longitude: CLLocationDegrees = 126.69873192498545
                        let result = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
                        DispatchQueue.main.async {
                            self.weather = result
                        }
                    } catch {
                        print("NetorkError: \(error)")
                    }
                }
            })
        }
//        .onAppear {
//            // 탭 바의 모양과 동작을 구성하는 코드
//            // 탭 바의 색상을 고정하는 코드
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground() // 배경을 불투명하게 설정
//            
//            // 선택되지 않은 탭의 색상
//            appearance.stackedLayoutAppearance.normal.iconColor = .gray
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
//            
//            // 선택된 탭의 색상
//            appearance.stackedLayoutAppearance.selected.iconColor = .blue
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.blue]
//            
//            // 탭 바에 적용
//            UITabBar.appearance().standardAppearance = appearance
//        }
    }
}
