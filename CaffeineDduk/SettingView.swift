//
//  SettingView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/13/24.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss  // 화면을 닫기 위한 dismiss 환경 변수
    
    var body: some View {
        VStack {
            Text("Settingview")
                .font(.largeTitle)
                .padding()

        }
        .navigationTitle("환경설정")  // 네비게이션 바의 제목 설정
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)  // 기본 백 버튼 숨기기
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
