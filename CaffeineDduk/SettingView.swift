//
//  SettingView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/13/24.
//

import Foundation
import SwiftUI
import SwiftData
import UserNotifications

struct SettingView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.dismiss) private var dismiss  // 화면을 닫기 위한 dismiss 환경 변수
    @Environment(\.modelContext) private var modelContext
    @State private var modifiedName = ""
    @Query private var user: [User]
    
    
    var body: some View {
        VStack {
            if let firstUser = user.first {
                Text(firstUser.name)  // 첫 번째 사용자의 이름만 표시
                    .font(.title)
                    .padding()
            } else {
                Text("노벨이")  // 사용자가 없을 경우
                    .font(.title)
            }
            
            TextField("                     수정할 이름을 입력하세요", text: $modifiedName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                modifiedUserName()
                viewModel.completeOnboarding()
            } label: {
                Text("변경하기")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width:200, height: 50)
                    .background(Color.accentColor)
                    .cornerRadius(6)
            }
            .padding()
            
        }
        .navigationTitle("환경설정")// 네비게이션 바의 제목 설정
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)  // 기본 백 버튼 숨기기
        .overlay{
            VStack(spacing: 0){
                Divider()
                    .padding(.bottom, 720)
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack{
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Main")
                            .foregroundColor(.blue)
                        
                    }
                }
            }
        }
    }
    private func modifiedUserName() {
        
        //let user = User(name: modifiedName)
        guard let userFirst = user.first else { return }
        userFirst.name = modifiedName
        modelContext.insert(userFirst)
        do {
            try modelContext.save()
            //print("User modified: \(user.name)")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
}

#Preview {
    SettingView(viewModel: ContentViewModel())
}
