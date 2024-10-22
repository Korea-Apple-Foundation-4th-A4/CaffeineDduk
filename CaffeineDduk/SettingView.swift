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
    @State private var modifiedName = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(120)
    @State private var notificationCount: Int = 10
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var selectedLanguage: String = "한국어"
    private let maxCharacterCount = 10
    
    
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
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            
            ZStack {
                TextField("수정할 이름을 입력하세요", text: $modifiedName)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(9)
                    .disableAutocorrection(true)
                    .onAppear {
                        if let firstUser = user.first {
                            modifiedName = firstUser.name
                            startTime = firstUser.startTime
                            endTime = firstUser.endTime
                            notificationCount = firstUser.notificationCount
                        } else {
                            modifiedName = "노벨이"
                        }
                    }
                    .onChange(of: modifiedName) { oldValue, newValue in
                        if newValue.count > maxCharacterCount {
                            modifiedName = String(newValue.prefix(maxCharacterCount))
                        }
                    }
                HStack {
                    Spacer()
                    Text("\(modifiedName.count)/\(maxCharacterCount)")
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.bottom, 36)
            
            
            
            
            
            Text("알림을 설정하세요")
                .fontWeight(.bold)
                .font(.title2)
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
                
                Text("\(notificationCount)x")
                    .font(.headline)
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
                    modifiedUser()
                    NotificationSetting.shared.removeAllNotifications()
                    NotificationSetting.shared.scheduleNotifications(enteredName: modifiedName, startTime: startTime, endTime: endTime, notificationCount: notificationCount)
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
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        selectedLanguage = "한국어"
                        print("한국어")
                    } label: {
                        if selectedLanguage == "한국어" {
                            Label("한국어", systemImage: "checkmark")
                        } else {
                            Text("한국어")
                        }
                    }
                    
                    Button {
                        selectedLanguage = "영어"
                        print("영어")
                    } label: {
                        if selectedLanguage == "영어" {
                            Label("영어", systemImage: "checkmark")
                        } else {
                            Text("영어")
                        }
                    }
                    
                    Button {
                        selectedLanguage = "중국어"
                        print("중국어")
                    } label: {
                        if selectedLanguage == "중국어" {
                            Label("중국어", systemImage: "checkmark")
                        } else {
                            Text("중국어")
                        }
                    }
                } label: {
                    Image(systemName: "globe")
                        .foregroundColor(.blue)
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
            showAlert = true
            return false
        }
        return true
    }
    
    // 태명 및 시간 변경
    private func modifiedUser() {
        guard let userFirst = user.first else { return }
        userFirst.name = modifiedName
        userFirst.startTime = startTime
        userFirst.endTime = endTime
        userFirst.notificationCount = notificationCount
        modelContext.insert(userFirst)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    
}


#Preview {
    SettingView(viewModel: ContentViewModel())
}
