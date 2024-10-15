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
    @State private var enteredName: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(120)
    @State private var notificationCount: Int = 10  // 알림 개수 설정
    
    var body: some View {
        VStack {
            Image("BabyOnboarding")
                .resizable()
                .scaledToFit()
                .padding(.horizontal,130)
                .padding(.bottom,30)

            Text("예쁜 태명을 지어주세요")
                .fontWeight(.bold)
                .font(.system(size:20))
            
            TextField("이름을 입력하세요", text: $enteredName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            Text("알림을 설정하세요")
                .fontWeight(.bold)
                .font(.system(size:20))
            
            
            DatePicker("시작 시간", selection: $startTime, displayedComponents: .hourAndMinute)
                .padding()
            
            DatePicker("종료 시간", selection: $endTime, displayedComponents: .hourAndMinute)
                .padding()
            
            HStack {
                Text("알림 개수: \(notificationCount)")  // 현재 알림 개수 표시
                Stepper("", value: $notificationCount, in: 1...20)  // 알림 개수를 1에서 20까지 조정 가능
                    .padding()
            }
            .padding()
            
            Button {
                saveUserName()
                saveNotificationSettings()  // 알림 설정 저장
                viewModel.completeOnboarding()
                scheduleNotifications()  // 여러 알림 예약
            } label: {
                Text("시작하기")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 50)
                    .background(Color.accentColor)
                    .cornerRadius(6)
            }
            .padding()
        }
        .onAppear {
            requestNotificationPermission()
        }
    }
    
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
