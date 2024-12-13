import SwiftUI
import FloatingButton

struct FloatingButtonView: View {
    var categoryID: Int
    
    var body: some View {
        ZStack {
            FloatingButton(
                mainButtonView: Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.keyColor)
                    .cornerRadius(30)
                    .shadow(radius: 10),
                buttons: [AnyView(EmptyView())]
            )
            .onTapGesture {
                if categoryID == 3 {
                    // '골라주세요' 탭 VoteWriteView로 이동
                    NavigationLink {
                        VoteWriteView(categoryID: 3)
                    } label: {
                        FloatingButtonView(categoryID: categoryID)
                    }
                } else {
                    // 나머지 탭 PostWriteView로 이동
                    NavigationLink {
                        PostWriteView(categoryID: categoryID)
                    } label: {
                        FloatingButtonView(categoryID: categoryID)
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    FloatingButtonView(categoryID: 1)
}
