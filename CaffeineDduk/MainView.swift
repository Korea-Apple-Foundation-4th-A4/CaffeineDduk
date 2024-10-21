//
//  MainView.swift
//  CaffeineDduk
//
//  Created by 지지 on 10/12/24.
//

import SwiftUI
import SwiftData
import UIKit

struct MainView: View {
    @Query private var user: [User]
    @StateObject private var viewModel = ContentViewModel()
    @State private var showText = false
    @State private var selectedSentence = ""
    @State private var timer: Timer?
    
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
                            
                            selectedSentence = sentences.randomElement() ?? "Hello"
                            showText = true
                            
                            // 진동 발생
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            
                            
                            // 타이머 취소
                            timer?.invalidate()
                            
                            // 타이머 시작
                            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                showText = false
                            }
                        }
                    if showText {
                        // 말풍선 뷰 사용
                        SpeechBubbleView(text: selectedSentence)
                            .offset(y: -170)
                    }
                }
                .padding(.top, 180)
                
                Spacer()
                
                if let firstUser = user.first {
                    Text(firstUser.name)
                        .font(.title)
                        .padding()
                } else {
                    Text("노벨이")
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


struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 말풍선 몸체 부분 (둥근 사각형)
        let bodyRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height - 20)
        path.addRoundedRect(in: bodyRect, cornerSize: CGSize(width: 15, height: 15))
        
        // 말풍선 꼬리 부분 (부드럽게 처리)
        let tailWidth: CGFloat = 20
        let tailHeight: CGFloat = 20
        
        path.move(to: CGPoint(x: rect.midX - tailWidth / 2, y: rect.height - tailHeight))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX + tailWidth / 2, y: rect.height - tailHeight),
            control: CGPoint(x: rect.midX, y: rect.height)
        )
        
        return path
    }
}

struct SpeechBubbleView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding()
            .padding(.bottom, 20)
            .background(
                SpeechBubble()
                    .fill(Color.yellow.opacity(0.7))
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
            )
            .frame(maxWidth: 350)
            .padding()
    }
}



#Preview {
    MainView()
}
