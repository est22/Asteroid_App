import SwiftUI

struct ClearableTextField: View {
    @Binding var text: String
    let placeholder: String
    var isError: Bool = false
    var isSuccess: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isError ? Color.red : 
                            isSuccess ? Color.gray.opacity(0.3) :
                            Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.5))
                }
                .padding(.trailing, 16)
            }
        }
    }
}
