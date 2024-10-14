//
//  CaffeineDdukApp.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftUI

@main
struct CaffeineDdukApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: User.self)  // User 모델을 포함하는 모델 컨테이너 생성
        }
    }
}
