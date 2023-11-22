//
//  ContentView.swift
//  POSO
//
//  Created by 박희경 on 2023/11/10.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    @StateObject var carStore = CarStore()
    @StateObject var weatherManager = WeatherManager()
    @StateObject var locationManager = LocationManager()
    
    @State private var tabViewSelectedIndex: Int = 0
    @State private var isModalPresented = true
    
    var body: some View {
        TabView(selection: $tabViewSelectedIndex) {
            HomeView(carStore: carStore, weatherManager: weatherManager, locationManager: locationManager)
                .tabItem {Image(systemName: "car.fill")}
                .tag(1)

            MyPageView(carStore: carStore)
                .tabItem { Image(systemName:  "drop.triangle" )}
                .tag(2)
        }
        .accentColor(.blue)
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
        }
        .onAppear(perform: {
            carStore.fetchInitialData() // realTime db 에서 유저 데이터 fetch
        })
        .onDisappear {
            carStore.stopListening()
        }
        
    }
}



