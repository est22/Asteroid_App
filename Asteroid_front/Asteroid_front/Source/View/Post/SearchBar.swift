import SwiftUI

struct SearchBar: View {
    @Binding var searchText:String
    @State var isEditing = false
    var handler:()->Void
    
    var body: some View {
        HStack {
            TextField("title, content", text: $searchText)
                .padding()
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 50))
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
                    Text("cancel")
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
