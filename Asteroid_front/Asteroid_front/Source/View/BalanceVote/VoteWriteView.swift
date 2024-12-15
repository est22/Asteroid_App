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
          Section(header: Text("제목")) {
            TextField("제목을 입력하세요", text: $title)
          }
          Section(header: Text("내용")) {
            TextEditor(text: $content)
              .frame(height: 300)
              .cornerRadius(8)
          }
          Section(header: Text("* 이미지 2개")) {
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
            .padding(.vertical, 4)
          }
        }
        
        Spacer()
        
        // 작성 완료 버튼
        Button {
          addVote()
        } label: {
          Text("작성 완료")
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.keyColor)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom)
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
