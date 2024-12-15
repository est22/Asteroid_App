import SwiftUI
 
struct PostWriteView: View {
    @StateObject var postVM = PostViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var images: [UIImage] = []
    @State private var isImagePickerPresented = false
    let categoryID:Int?
    var post: Post?
   
  init(categoryID: Int? = nil, post: Post? = nil) {
      self.categoryID = categoryID
      self.post = post
      if let post = post {
          _title = State(initialValue: post.title)
          _content = State(initialValue: post.content)
          _images = State(initialValue: post.PostImages?.compactMap { UIImage(named: $0.imageURL!) } ?? [])
      }
  }
    
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
                    Section(header: Text("이미지")) {
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
                    if let post = post {
                      updatePost(post)
                    } else {
                        addPost()
                    }
                } label: {
                    Text("완료")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.keyColor)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            
            .sheet(isPresented: $isImagePickerPresented) {
                PostImagePicker(images: $images)
            }
        }
    }

    // 게시물 추가
    private func addPost() {
        guard !title.isEmpty, !content.isEmpty else {
            postVM.message = "제목과 내용을 입력해주세요."
            return
        }
        guard let categoryID else {return}

        // 필요한 데이터 전달
        postVM.addPost(
            title: title,
            content: content,
            categoryID: categoryID,
            images: images
        )
        
        dismiss()
    }
  
    // 게시글 수정
    private func updatePost(_ post: Post) {
          guard !title.isEmpty, !content.isEmpty else {
              postVM.message = "제목과 내용을 입력해주세요."
              return
          }
          postVM.updatePost(
              postId: post.id,
              title: title,
              content: content,
              categoryID: post.categoryID,
              images: images
          )
      }
}



#Preview {
    let postVM = PostViewModel()
    PostWriteView().environmentObject(postVM)
}

