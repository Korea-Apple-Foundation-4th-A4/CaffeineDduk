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
//    func scheduleNotifications(enteredName: String, startTime: Date, endTime: Date, notificationCount: Int) {
//        // 종료 시간이 시작 시간보다 빠른 경우, 다음날로 조정
//        let adjustedEndTime: Date
//        if startTime > endTime {
//            adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
//        } else {
//            adjustedEndTime = endTime
//        }
//        
//        // 총 기간 및 간격 계산
//        let totalDuration = adjustedEndTime.timeIntervalSince(startTime)
//        let interval = totalDuration / Double(notificationCount)
//
//        // 알림 예약
//        for i in 0..<notificationCount {
//            let notificationTime = startTime.addingTimeInterval(Double(i) * interval)
//
//            // 알림이 현재 시간보다 이전인 경우, 다음날로 조정
//            let triggerDate: Date
//            if notificationTime < Date() {
//                triggerDate = Calendar.current.date(byAdding: .day, value: 1, to: notificationTime)!
//            } else {
//                triggerDate = notificationTime
//            }
//
//            let content = UNMutableNotificationContent()
//            content.title = "카페인뚝"
//            let randomSentence = Sentences.all.randomElement() ?? "엄마, 오늘은 커피 대신 사랑 한 잔 어때요?"
//            content.body = "\(randomSentence) - \(enteredName)"
//            content.sound = .default
//
//            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
//            dateComponents.second = 0
//
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("알림 추가 실패: \(error)")
//                } else {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    let formattedDate = dateFormatter.string(from: triggerDate)
//                    print("알림 요청 성공: \(formattedDate)")
//                }
//            }
//        }
//    }
    
    func scheduleNotifications(enteredName: String, startTime: Date, endTime: Date, notificationCount: Int) {
        
        // 시작시간과 종료시간에서 시간 컴포넌트 추출
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.hour, .minute, .second], from: startTime)
        var endComponents = calendar.dateComponents([.hour, .minute, .second], from: endTime)
        
        // 현재 날짜 기준으로 시작/종료 시간 생성
        let today = Date()
        var todayStartTime = calendar.date(bySettingHour: startComponents.hour ?? 0,
                                         minute: startComponents.minute ?? 0,
                                         second: startComponents.second ?? 0,
                                         of: today)!
        var todayEndTime = calendar.date(bySettingHour: endComponents.hour ?? 0,
                                       minute: endComponents.minute ?? 0,
                                       second: endComponents.second ?? 0,  // endComponents의 초를 사용
                                       of: today)!
        
        // 종료 시간이 시작 시간보다 이전이면 다음날로 조정
        if todayStartTime > todayEndTime {
            todayEndTime = calendar.date(byAdding: .day, value: 1, to: todayEndTime)!
        }
        
        // 총 기간 및 간격 계산
        let totalDuration = todayEndTime.timeIntervalSince(todayStartTime)
        let interval = totalDuration / Double(notificationCount - 1) // 마지막 알림이 종료 시간에 맞도록 조정
        
        print("=== 알림 스케줄 정보 ===")
        print("시작 시간: \(todayStartTime)")
        print("종료 시간: \(todayEndTime)")
        print("총 기간(초): \(totalDuration)")
        print("알림 간격(초): \(interval)")
        
        // 알림 예약
        for i in 0..<notificationCount {
            let notificationTime = todayStartTime.addingTimeInterval(Double(i) * interval)
            
            let content = UNMutableNotificationContent()
            content.title = "카페인뚝"
            let randomSentence = Sentences.all.randomElement() ?? "엄마, 오늘은 커피 대신 사랑 한 잔 어때요?"
            content.body = "\(randomSentence) - \(enteredName)"
            content.sound = .default
            
            // 시간 컴포넌트 추출 (초 단위 포함)
            var triggerComponents = calendar.dateComponents([.hour, .minute, .second], from: notificationTime)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "DailyCaffeine_\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 추가 실패 [\(i)]: \(error)")
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    let formattedTime = dateFormatter.string(from: notificationTime)
                    print("알림 [\(i)] 예약 완료: 매일 \(formattedTime)")
                }
            }
        }
        
    }


    
}
