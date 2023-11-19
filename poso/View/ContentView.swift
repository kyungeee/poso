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
    @State private var isModalPresented = true
    
    var body: some View {
        TabView(selection: $tabViewSelectedIndex) {
            HomeView(weather: weather ?? nil)
//                .overlay(isModalPresented ? ModalView() : ModalView())
                .tabItem {Image(systemName: "car.fill")}
                .tag(1)
//                .sheet(isPresented: $isModalPresented) {
//                    ModalView()
//                        .presentationDetents([.height(250)])
//                    //                                        .presentationBackgroundInteraction(.enabled(upThrough: .height(250)))
//                        .presentationCornerRadius(20)
//                        .padding(.bottom, 100)
//
//                }
            
            if let weather = weather {
                MyPageView(weather: weather)
                    .tabItem { Image(systemName:  "drop.triangle" )}
                    .tag(2)
            }
        }
        .accentColor(.blue)
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
        }
        .onAppear(perform: {
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
}



