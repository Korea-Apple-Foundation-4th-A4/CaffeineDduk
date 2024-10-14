//
//  SplashView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.accentColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 100))
                Text("카페인, 뚝!")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    SplashView()
}
