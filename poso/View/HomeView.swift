//
//  HomeView.swift
//  poso
//
//  Created by 박희경 on 2023/11/18.
//

import SwiftUI


struct HomeView: View {
    @State private var isModalPresented = true
    @State var weather: ResponseBody?
    @State private var region: String = "침수 위험 높음"
    @State var rain: String = "40mm"
    @State var waterSensor: String = "80%"
    
    var body: some View {
        ZStack {
            MapView()
                .sheet(isPresented: $isModalPresented) {
                                    ModalView()
                                        .presentationDetents([.height(250)])
                                    //                                        .presentationBackgroundInteraction(.enabled(upThrough: .height(250)))
                                        .presentationCornerRadius(20)
                                        .padding(.bottom, 100)
                
                                }
            
            VStack {
                Spacer()
                VStack() {
                    VStack {
                        HStack{
                            Text("MyGenesis")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Text("내 차량 위치: 19 Janggogae-ro 309beon-gil, Seo-gu, Incheon")
                            .font(.caption)
                            .foregroundColor(.black)
                    }.padding(.bottom, 20)
                    
                    Divider()
                        .padding(.bottom, 30)
                    
                    HStack {
                        HStack {
                            //                            WeatherRow(logo: "cloud.rain", name: "precipitation", value: "50mm").frame(height: 20)
                            //                            Spacer()
//                            WeatherRow(logo: "exclamationmark.triangle.fill", name: "위험단계", value: "높음").frame(height: 20)
//                            
                            HomeRow(title: "지역", description: $region)
                                .padding(.trailing, 20)
                            VerticalDivider()
                            HomeRow(title: "강수량", description: $rain)
                                .padding(.horizontal, 20)
                            VerticalDivider()
                            HomeRow(title: "물 감지 센서", description: $waterSensor)
                                .padding(.leading, 20)
                            
                        }
//                        Text("센서 물 감지 퍼센트")
//                            .fontWeight(.light)
//                            .padding(.bottom, -10)
                        
//                        HStack {
//                            Spacer()
//                            ProgressBar(progress: self.$progressValue)
//                                .frame(width: 150.0, height: 150.0)
//                                .padding(40.0)
//                            Spacer()
//                        }
                        
//                        Button(action: {
//                            self.incrementProgress()
//                        }) {
//                            HStack {
//                                Image(systemName: "plus.rectangle.fill")
//                                Text("Increment")
//                            }
//                            .padding(15.0)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 15.0)
//                                    .stroke(lineWidth: 2.0)
//                            )
//                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(25)
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
    }
    
}

struct HomeRow: View {
    var title: String
    @Binding var description: String
    
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
//        .padding()
//        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
//        .cornerRadius(20, corners: .allCorners)
    }
}


struct VerticalDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 1, height: 20)
        
    }
}


