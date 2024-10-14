//
//  ContentView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

// ContentView.swift
import SwiftUI
import SwiftData

class ContentViewModel: ObservableObject {
    @AppStorage("_isFirstRun") var isFirstRun: Bool = true  // 첫 실행 여부를 저장하는 변수
    
    func completeOnboarding() {
        isFirstRun = false  // 온보딩 완료 후 첫 실행 상태를 false로 변경
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()  // viewModel 인스턴스 생성
    @State private var isShowingSplash = true  // 스플래쉬 화면 표시 여부를 위한 상태 변수
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashView()  // 스플래쉬 화면
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  // 1초 후 스플래쉬 화면 제거
                            withAnimation {
                                isShowingSplash = false
                            }
                        }
                    }
            } else {
                if viewModel.isFirstRun {
                    OnboardingPageView(viewModel: viewModel)  // OnboardingPageView 호출
                } else {
                    MainView()  // MainView로 전환
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
