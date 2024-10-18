//
//  CaffeineDdukApp.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftUI

@main
struct CaffeineDdukApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // AppDelegate 등록

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [User.self])  // User 모델을 포함하는 모델 컨테이너 생성
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self  // Delegate 설정
        return true
    }

    // 포그라운드 상태에서 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])  // 배너와 사운드로 알림 표시
    }
}


