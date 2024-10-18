//
//  MainView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Query private var user: [User]
    @StateObject private var viewModel = ContentViewModel()
    @State private var showText = false
    @State private var selectedSentence = ""
    
    // 10개의 미리 정해진 문장 배열
    let sentences = [
        "엄마, 오늘은 커피 대신 사랑 한 잔 어때요?",
        "엄마, 내가 힘내게 커피 대신 사랑 한 잔 주세요",
        "엄마, 오늘 커피 대신 사랑으로 하루를 채워봐요!",
        "오늘은 엄마에게 기분 좋은 일이 가득할 거예요!",
        "신은 모든 곳에 있을 수 없기에 엄마를 만들었대요.",
        "엄마, 사랑해요! 오늘을 환하게 만들어봐요!",
        "엄마, 오늘도 활짝 웃어봐요! 제가 응원할게요!",
        "엄마, 오늘 하루도 따뜻하게 보내요!",
        "엄마, 힘들 땐 제가 엄마를 꼭 안아줄게요",
        "妈妈，我爱你，今天也要健康哦!",
        "妈妈，喝果汁吧!",
        "妈妈，今天喝一杯爱，替代咖啡，好吗?",
        "喝水吧妈妈，这样我们都会更健康!",
        "Mom, how about a cup of love instead of coffee today?",
        "Mom, I love you! Let’s brighten today together!",
        "Today will be full of good things for you, mom!",
        "God couldn’t be everywhere, so He made mothers",
        "Mom, smile big today! I’m cheering you on!",
        "Mom, have a warm and wonderful day!",
        "Let’s stay happy and healthy together, mom!",
        "Take a break, mom, and feel the love!"
    ]

    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("BabyMain")
                        .padding(.top, 50)
                        .onTapGesture {
                            // 이미지 클릭 시, 무작위 문장 선택 및 텍스트 표시
                            selectedSentence = sentences.randomElement() ?? "Hello"
                            showText = true
                            
                            // 텍스트 숨기기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                showText = false
                            }
                        }
                    if showText {
                        Text(selectedSentence)
                            .font(.title)
                            .background(Color.yellow.opacity(0.7))  // 텍스트 배경색 추가 (선택 사항)
                            .cornerRadius(10)
                            .offset(y: -230)  // 이미지 위로 텍스트를 배치
                    }
                }
                .padding(.top, 180)
                
                Spacer()
                
                
                
                
                // 사용자의 이름을 가져오는 코드
                if let firstUser = user.first {
                    Text(firstUser.name)  // 첫 번째 사용자의 이름만 표시
                        .font(.title)
                        .padding()
                } else {
                    Text("노벨이")  // 사용자가 없을 경우
                        .font(.title)
                        .padding()
                }
            }
            .padding(.bottom, 120)
            .onAppear {
                print("Users loaded: \(user)")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView(viewModel: viewModel)) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                    
                }
                
            }
        }
    }
}


#Preview {
    MainView()
}
