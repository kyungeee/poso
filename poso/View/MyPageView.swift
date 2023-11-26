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
                            }
                            .frame(width: 150, alignment: .leading)
                        }
                        
                    }
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Spacer()
                        .frame(height:  40)
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
                MessageComposeView(messageBody: " [POSO APP] 현재 차량이 침수되었습니다! 구조바랍니다.⚠️ 현재 차량 위치: 인천대학교 지하 1층 지하주차장 B-11 / 차량 번호: 331소 8967", recipients: ["+821094240754"])
            }
            .padding(.bottom, 300)
            .padding(.horizontal)
            
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack{
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("현재 차량 위치: 인천대학교 지하 1층 지하주차장 B-11")
                                .font(.caption)
                                .foregroundColor(.black)
                            Text("차량 번호: 331소 8967")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            self.isMessageComposeVisible.toggle()
                            
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

                        HStack {
                            Spacer()
                            if let data = carStore.car {
                                ProgressBar(progress: data.progressBarState, text: data.progressBarText)
                                    .frame(width: 150.0, height: 150.0)
                                    .padding(40.0)
                            }
                            Spacer()
                        }
                    }
                    
                    if let weather = carStore.weather, let car = carStore.car {
                        HStack {
//                            WeatherRow(logo: "cloud.rain", name: "precipitation", value: "\(weather.rain?.the1H ?? 0)mm")
                            WeatherRow(logo: "cloud.rain", name: "precipitation", value: "250mm")
                            Spacer()
                            WeatherRow(logo: "humidity", name: "water sensor", value: "\(car.waterValue)")
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }

        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .onAppear {

        }
    }
    
    func incrementProgress() {
        let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
        self.progressValue += randomValue
    }
    
    func sendMessage() {
        let sms: String = "sms:+821025888219&body=현재 차량 위치: 인천대학교 지하 1층 지하주차장 B-11 / 차량 번호: 331소 8967"
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
