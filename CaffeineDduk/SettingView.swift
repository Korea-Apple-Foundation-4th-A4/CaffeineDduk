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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var user: [User]
    @Query private var notificationSettings: [NotificationSettings]
    @State private var modifiedName = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(120)
    @State private var notificationCount: Int = 10
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    
    
    
    
    var body: some View {
        VStack {
            Image("BabySetting")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .padding(.bottom,36)
                .padding(.top, 36)
            
            Text("예쁜 태명을 지어주세요")
                .fontWeight(.bold)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            TextField("수정할 이름을 입력하세요", text: $modifiedName)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(9)
                .disableAutocorrection(true)
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
                .onAppear {
                    if let firstUser = user.first {
                        modifiedName = firstUser.name
                    } else {
                        modifiedName = "노벨이"
                    }
                }
            
            Text("알림을 설정하세요")
                .fontWeight(.bold)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            // 주기 설정 뷰
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 60)
                
                HStack {
                    Text("얼마나")
                        .font(.headline)
                    
                    Stepper("", value: $notificationCount, in: 1...20)
                    
                }
                .padding(.horizontal, 16)
                
                Text("\(notificationCount)") // 알림 개수 표시
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 16)
            
            // 시간 설정 뷰
            ZStack{
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 120)
                VStack{
                    DatePicker("시작 시간 :", selection: $startTime, displayedComponents: .hourAndMinute)
                        .font(.headline)
                    Divider()
                    DatePicker("종료 시간 :", selection: $endTime, displayedComponents: .hourAndMinute)
                        .font(.headline)
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            // 버튼
            Button {
                if textIsAppropriate() {
                    modifiedUserName()
                    viewModel.completeOnboarding()
                    dismiss()
                }
                
            } label: {
                Text("변경하기")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.accentColor)
                    .cornerRadius(9)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 36)
            
        }
        .navigationTitle("환경설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle))
        }
    }
    
    // 태명 미입력시 경고
    private func textIsAppropriate() -> Bool {
        if modifiedName.isEmpty {
            alertTitle = "예쁜 태명을 꼭 지어주세요"
            showAlert = true  // 알림 표시
            return false
        }
        return true
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
