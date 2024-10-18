//
//  OnboardingPageView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct OnboardingPageView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var user: [User]
    @State private var enteredName: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(120)
    @State private var notificationCount: Int = 10
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    
    var body: some View {
        VStack {
            Image("BabyOnboarding")
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
            
            
            TextField("여기에 입력하세요", text: $enteredName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(9)
                .disableAutocorrection(true) // 자동수정 비활성화
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
            
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
                    saveUser()
                    viewModel.completeOnboarding()
                    NotificationSetting.shared.scheduleNotifications(enteredName: enteredName, startTime: startTime, endTime: endTime, notificationCount: notificationCount)
                }
            } label: {
                Text("시작하기")
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
        // 경고 표시
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle))
        }
        .onAppear {
            requestNotificationPermission()
        }
    }
    
    
    // 태명 미입력시 경고
    func textIsAppropriate() -> Bool {
        if enteredName.count < 1 {
            alertTitle = "예쁜 태명을 꼭 지어주세요"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    private func saveUser() {
        let user = User(name: enteredName, startTime: startTime, endTime: endTime, notificationCount: notificationCount)
        modelContext.insert(user)
        do {
            try modelContext.save()
            print("User saved: \(user.name), Start: \(user.startTime), End: \(user.endTime), Count: \(user.notificationCount)")
        } catch {
            print("Failed to save user: \(error)")
        }
    }

    // 알림 권한 요청
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error)")
                return
            }
            if granted {
                print("알림 권한이 허가되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
}




#Preview {
    OnboardingPageView(viewModel: ContentViewModel())
}
