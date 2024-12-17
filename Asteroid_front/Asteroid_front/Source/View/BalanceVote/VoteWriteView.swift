import SwiftUI

struct VoteWriteView: View {
  @StateObject var voteVM = BalanceVoteViewModel()
  @Environment(\.dismiss) var dismiss
  
  @State private var title = ""
  @State private var content = ""
  @State private var images: [UIImage] = []
  @State private var isImagePickerPresented = false
  
  var body: some View {
    NavigationView {
      VStack {
          Form {
              Section(header: Text("제목").padding(.horizontal, 5)) {
                  TextField("제목을 입력하세요", text: $title)
                      .padding(.vertical, 10)
                      .padding(.horizontal, 10)
                      .background(Color(.systemGray6))
                      .cornerRadius(8)
              }
              .listRowInsets(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
              
              Section(header: Text("내용").padding(.horizontal, 5)) {
                  TextEditor(text: $content)
                      .frame(height: 300)
                      .padding(.vertical, 12)
                      .padding(.horizontal, 8)
                      .background(Color(.systemGray6))
                      .cornerRadius(8)
              }
              .listRowInsets(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
              
              Section(header: Text("이미지").padding(.horizontal, 10)) {
                  ScrollView(.horizontal, showsIndicators: false) {
                      HStack {
                          Button(action: {
                              isImagePickerPresented = true
                          }) {
                              VStack {
                                  Image(systemName: "plus")
                                      .font(.largeTitle)
                                      .foregroundColor(.gray)
                              }
                              .frame(width: 100, height: 100)
                              .background(Color(.systemGray6))
                              .cornerRadius(8)
                          }
                          .padding(.leading, 8)
                          
                          ForEach(images, id: \.self) { image in
                              Image(uiImage: image)
                                  .resizable()
                                  .scaledToFill()
                                  .frame(width: 100, height: 100)
                                  .cornerRadius(8)
                                  .clipped()
                          }
                      }
                  }
                  .padding(.vertical, 2)
              }
              .listRowInsets(EdgeInsets(top: 0, leading: -3, bottom: 0, trailing: 0))
              
          }
          .scrollContentBackground(.hidden)
          .background(Color.white)


          
          // 작성 완료 버튼
          Button {
              addVote()
          } label: {
              Text("완료")
                  .font(.system(size: 18, weight: .bold))
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .frame(height: 50)
                  .background(Color.keyColor)
                  .cornerRadius(12)
                  .padding(.horizontal)
                  .padding(.vertical, 16)
          }
        .disabled(images.count != 2)
      }
      .sheet(isPresented: $isImagePickerPresented) {
        PostImagePicker(images: $images, imageLimit: 2)
      }
    }
  }
  
  // 게시물 추가
  private func addVote() {
    guard !title.isEmpty, !content.isEmpty else {
      voteVM.message = "제목과 내용을 입력해주세요."
      return
    }
    guard images.count == 2 else {
      voteVM.message = "이미지를 2개 선택해주세요."
      return
    }
    
    voteVM.addVote(title: title, description: content,
                   image1: images[0], image2: images[1])
    dismiss()
  }
}

#Preview {
  VoteWriteView()
}
