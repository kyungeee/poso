//
//  MyView.swift
//  POSO
//
//  Created by 박희경 on 2023/11/15.
//

import SwiftUI
import CoreLocation
import Combine
import UIKit
import MessageUI


struct MyPageView: View {
    // Replace YOUR_API_KEY in WeatherManager with your own API key for the app to work
    @ObservedObject var carStore: CarStore
    @StateObject var locationManager = LocationManager()
//    @State var weather: Weather
    @State var rain: String = "0"
    @State var progressValue: Float = 0.8
    @State private var isMessageComposeVisible = false
    
    var weatherManager = WeatherManager()
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        if let weather = carStore.weather {
                            Text(weather.name)
                                .bold()
                                .font(.title)
                            
                            VStack(spacing: 20) {
                                Image(systemName: "cloud")
                                    .font(.system(size: 20))
                                
                                //                            Text("\(weather.weather[0].main)")
                            }
                            .frame(width: 150, alignment: .leading)
                        }
                        
                    }
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                
//                Spacer()
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
//                    HStack {
//                        VStack(spacing: 20) {
//                            Image(systemName: "cloud")
//                                .font(.system(size: 40))
//                            
//                            Text("\(weather.weather[0].main)")
//                        }
//                        .frame(width: 150, alignment: .leading)
//                        
//                        Spacer()
//                        
//                        Text(weather.main.feelsLike.roundDouble() + "°")
//                            .font(.system(size: 100))
//                            .fontWeight(.bold)
//                            .padding()
//                    }
                    
                    Spacer()
                        .frame(height:  80)
                    HStack(alignment: .center) {
                        Spacer()
                        Image(uiImage: UIImage(named: "genesisgv70")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 280)
                            .padding(.bottom, 40)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .sheet(isPresented: $isMessageComposeVisible) {
                       MessageComposeView(messageBody: "Hello", recipients: ["+821025888219"])
                   }
            .padding(.bottom, 300)
            .padding(.horizontal)
//            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack{
                        Text("Weather now")
                            .bold()
                        Spacer()
                        
                        Button(action: {
                                                        self.isMessageComposeVisible.toggle()
//                            sendMessage()
                            //                            if let url = URL(string: "tel://119") {
                            //                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            //                            }
                        }, label: {
                            VStack {
                                Image(systemName: "exclamationmark.bubble.circle.fill")
                                    .font(.largeTitle)
                                Text("침수 신고")
                                    .font(.callout)
                            }
                        })
                    }
                   
                    VStack {
//                        Text("센서 물 감지 퍼센트")
//                            .fontWeight(.light)
//                            .padding(.bottom, -10)
                        
                        HStack {
                            Spacer()
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 150.0, height: 150.0)
                                .padding(40.0)
                            Spacer()
                        }
                        
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
                    
                    if let weather = carStore.weather {
                        HStack {
                            WeatherRow(logo: "cloud.rain", name: "precipitation", value: "\(weather.rain?.the1H ?? 0)mm")
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity)%")
                        }
                    }
                    
//                    HStack {
//                        if let car = carStore.car {
//                            WeatherRow(logo: "cloud.rain", name: "logtitude", value: "\(car.logitude)")
//                            Spacer()
//                            WeatherRow(logo: "humidity", name: "latitude", value: "\(car.latitude)")
//                        }
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
//        .edgesIgnoringSafeArea(.bottom)
//        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))

        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
//        .preferredColorScheme(.dark)
        .onAppear {
//            if let rainData = weather.rain {
//                self.rain = String(rainData.the1H)
//            }
        }
    }
    
    func incrementProgress() {
        let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
        self.progressValue += randomValue
    }
    
    func sendMessage() {
        let sms: String = "sms:+821025888219&body=Hello"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
}
//
//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(weather: previewWeather)
//    }
//}

struct MessageComposeView: UIViewControllerRepresentable {
    let messageBody: String
    let recipients: [String]

    func makeUIViewController(context: Context) -> UIViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.body = messageBody
        messageComposeVC.recipients = recipients
        messageComposeVC.messageComposeDelegate = context.coordinator
        return messageComposeVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
}
