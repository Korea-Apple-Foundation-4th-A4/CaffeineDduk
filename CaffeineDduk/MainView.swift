// MainView.swift
import SwiftUI
import SwiftData

struct MainView: View {
    @Query private var user: [User]  // SwiftData에서 User 데이터 가져오기
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("MainView")
                    .font(.largeTitle)
                    .padding()
                
                // 사용자 수 확인
                Text("User count: \(user.count)")  // 사용자 수 표시
                
                // 첫 번째 사용자의 이름을 가져오는 코드
                if let firstUser = user.first {
                    Text(firstUser.name)  // 첫 번째 사용자의 이름만 표시
                        .font(.title)
                        .padding()
                } else {
                    Text("No user found.")  // 사용자가 없을 경우
                        .font(.title)
                        .padding()
                }
            }
            .onAppear {
                print("Users loaded: \(user)")  // 불러온 사용자 정보 출력
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()) {
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
