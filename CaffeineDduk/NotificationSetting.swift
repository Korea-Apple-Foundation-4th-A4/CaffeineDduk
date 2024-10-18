//
//  NotificationSetting.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/14/24.
//


import SwiftData
import UserNotifications

class NotificationSetting {
    static let shared = NotificationSetting()
    
    private init() {}  // Singleton 패턴으로 하나의 인스턴스만 사용하도록 제한
    
    // 기존 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 알림 예약
    func scheduleNotifications(enteredName: String, startTime: Date, endTime: Date, notificationCount: Int) {
        let adjustedEndTime: Date
        if startTime > endTime {
            adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        } else {
            adjustedEndTime = endTime
        }
        
        let totalDuration = adjustedEndTime.timeIntervalSince(startTime)
        let interval = totalDuration / Double(notificationCount)
        
        for i in 0..<notificationCount {
            let notificationTime = startTime.addingTimeInterval(Double(i) * interval)
            
            let triggerDate: Date
            if notificationTime < Date() {
                triggerDate = Calendar.current.date(byAdding: .day, value: 1, to: notificationTime)!
            } else {
                triggerDate = notificationTime
            }
            
            let content = UNMutableNotificationContent()
            content.title = "안녕, 내 이름은 \(enteredName)(이)야!"
            content.body = "엄마 커피 한 잔 대신 사랑 한 잔 어때요?"
            content.sound = .default
            
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
            dateComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 추가 실패: \(error)")
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let formattedDate = dateFormatter.string(from: triggerDate)
                    print("알림 요청 성공: \(formattedDate)")
                }
            }
        }
    }
    
}
