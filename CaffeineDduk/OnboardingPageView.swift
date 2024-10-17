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
                .foregroundColor(.black)
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
                    
                    Stepper("", value: $notificationCount, in: 1...20)  // 알림 개수를 1에서 20까지 조정 가능
                    
                }
                .padding(.horizontal, 16)
                
                Text("\(notificationCount)x") // 알림 개수 표시
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
                    saveUserName()
                    saveNotificationSettings()  // 알림 설정 저장
                    viewModel.completeOnboarding()
                    scheduleNotifications()  // 여러 알림 예약
                }
            } label: {
                Text("시작하기")                                                                 // 시작하기? 계속하기?
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
            alertTitle = "예쁜 태명을 꼭 지어주세요"                                                  // 멘트 수정 필요
            showAlert.toggle()
            return false
        }
        return true
    }
    
    // 태명 저장
    private func saveUserName() {
        let user = User(name: enteredName)
        modelContext.insert(user)
        do {
            try modelContext.save()
            print("User saved: \(user.name)")
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
    
    // 알림 설정 저장
    private func saveNotificationSettings() {
        let settings = NotificationSettings(startTime: startTime, endTime: endTime, notificationCount: notificationCount)
        modelContext.insert(settings)
        do {
            try modelContext.save()
            print("Notification settings saved: Start: \(settings.startTime), End: \(settings.endTime), Count: \(settings.notificationCount)")
        } catch {
            print("Failed to save notification settings: \(error)")
        }
    }
    
    
    
    // 알림 수신
    private func scheduleNotifications() {
        // 종료 시간이 시작 시간보다 이전일 경우 다음날로 조정
        let adjustedEndTime: Date
        if startTime > endTime {
            adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        } else {
            adjustedEndTime = endTime
        }
        
        let totalNotifications = notificationCount
        let totalDuration = adjustedEndTime.timeIntervalSince(startTime)
        
        // 알림 간격 계산
        let interval = totalDuration / Double(totalNotifications)
        
        for i in 0..<totalNotifications {
            let notificationTime = startTime.addingTimeInterval(Double(i) * interval)
            
            // 현재 시간이 알림 시간보다 이전인 경우
            var triggerDate: Date
            if notificationTime < Date() {
                // 알림 시간 설정이 지나쳤으므로 다음 날로 설정
                triggerDate = Calendar.current.date(byAdding: .day, value: 1, to: notificationTime)!
            } else {
                triggerDate = notificationTime
            }
            
            
            
            let content = UNMutableNotificationContent()
            content.title = "안녕, 내 이름은 \(enteredName)(이)야!"
            content.body = "엄마 커피 한 잔 대신 사랑 한 잔 어때요?"
            content.sound = .default
            
            // 매일 반복하도록 설정
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
            dateComponents.second = 0 // 초는 0으로 설정
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 요청 추가 실패: \(error)")
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 형식으로 조정
                    let formattedDate = dateFormatter.string(from: triggerDate)
                    print("알림 요청 성공: \(formattedDate)") // 포맷된 시간 출력
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}




#Preview {
    OnboardingPageView(viewModel: ContentViewModel())
}
