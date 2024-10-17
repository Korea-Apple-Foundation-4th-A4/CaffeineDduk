// MainView.swift
import SwiftUI
import SwiftData

struct MainView: View {
    @Query private var user: [User]
    @StateObject private var viewModel = ContentViewModel()
    @State private var showText = false
    @State private var selectedSentence = ""
    
    // 10개의 미리 정해진 문장 배열
    let sentences = [
        "Hello!", "How are you?", "Welcome!", "Good day!", "Stay positive!",
        "You're awesome!", "Keep going!", "Enjoy the moment!", "Believe in yourself!",
        "You can do it!"
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
                            .foregroundColor(.black)
                            .background(Color.yellow.opacity(0.7))  // 텍스트 배경색 추가 (선택 사항)
                            .cornerRadius(10)
                            .offset(y: -200)  // 이미지 위로 텍스트를 배치
                    }
                }
                .padding(.top, 100)
                
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
            .padding(.bottom, 36)
            .onAppear {
                print("Users loaded: \(user)")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView(viewModel: viewModel)) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.black)
                    }
                    
                }
                
            }
        }
    }
}


#Preview {
    MainView()
}
