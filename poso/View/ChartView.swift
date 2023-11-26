//
//  ChartView.swift
//  poso
//
//  Created by 박희경 on 2023/11/16.
//

import SwiftUI


struct ProgressBar: View {
    var progress: Float
    var text: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 30.0)
                .opacity(0.3)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            VStack(alignment: .center) {
                HStack {
                    Text("\(text)")
                        .font(.system(size: 15))
                        .foregroundColor(.red)
                }
                Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}
