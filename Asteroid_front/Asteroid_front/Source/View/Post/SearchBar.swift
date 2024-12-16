import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State var isEditing = false
    var handler: () -> Void
    
    var body: some View {
        HStack {
            TextField("제목, 내용으로 검색", text: $searchText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 12))
                .padding(.horizontal)
                .onSubmit {
                    handler()
                }
                .onTapGesture {
                    isEditing = true
                }
                .animation(.easeInOut, value: isEditing)
            
            if isEditing {
                Button {
                    isEditing = false
                    self.searchText = ""
                } label: {
                    Text("취소")
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 10)
                .transition(.identity)
            }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant("")) {
        
    }
}
