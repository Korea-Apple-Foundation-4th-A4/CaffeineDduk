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
    @Environment(\.modelContext) private var modelContext  // SwiftData context 접근
    @State private var enteredName: String = ""  // 입력된 이름을 임시로 저장
//    @State private var startTime: Date = Date()  // 알림 시작 시간
//    @State private var endTime: Date = Date().addingTimeInterval(3600)  // 알림 종료 시간
//    @State private var notificationCount: String = "1"  // 알림 개수 (문자열로 받아옴)--------------문자열이 맞나?


    var body: some View {
        VStack {
            Text("온보딩 테스트")
            
            // 이름을 입력받는 TextField
            TextField("이름을 입력하세요", text: $enteredName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            // 온보딩 완료 버튼.
            Button {
                saveUserName()  // 이름 저장 함수 호출
                viewModel.completeOnboarding()
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
    }
    
    private func saveUserName() {
        let user = User(name: enteredName)  // 입력된 이름으로 User 인스턴스 생성
        modelContext.insert(user)  // SwiftData context에 user를 추가
        do {
            try modelContext.save()  // context 저장
            print("User saved: \(user.name)")  // 저장된 사용자 이름 출력
        } catch {
            print("Failed to save user: \(error)")  // 에러 출력
        }
    }
}


#Preview {
    OnboardingPageView(viewModel: ContentViewModel())
}


