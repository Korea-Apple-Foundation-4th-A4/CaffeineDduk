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
                Image("BabySplash")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 100)
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 130)
                //                    .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                
            }
        }
    }
}

#Preview {
    SplashView()
}
