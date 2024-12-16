import SwiftUI
import FloatingButton

struct FloatingButtonView: View {
  var onMainButtonTap: () -> Void
  
  var body: some View {
    ZStack {
      FloatingButton(
        mainButtonView:
          Button {
            onMainButtonTap()
          } label: {
            Image(systemName: "plus")
              .font(.title)
              .foregroundColor(.white)
              .frame(width: 50, height: 50)
              .background(Color.keyColor)
              .cornerRadius(30)
          },
        buttons: [AnyView(EmptyView())]
      )
    }
  }
}

#Preview {
  FloatingButtonView(){}
}
