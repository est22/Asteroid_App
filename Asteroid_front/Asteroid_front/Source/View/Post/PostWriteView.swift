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
    @State private var navigateToDetail = false
    @State private var newPostId: Int?
   
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
        NavigationStack {
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
                    if let post = post {
                        updatePost(post)
                    } else {
                        addPost()
                    }
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
                .background(Color.white)
                .sheet(isPresented: $isImagePickerPresented) {
                    PostImagePicker(images: $images, imageLimit: 10) 
                }
                .background(Color.white)
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                if let postId = newPostId {
                    PostDetailView(postID: postId)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }

    // 게시물 추가
    private func addPost() {
        guard !title.isEmpty, !content.isEmpty else {
            postVM.message = "제목과 내용을 입력해주세요."
            return
        }
        guard let categoryID else { return }
        
        Task {
            if let postId = await postVM.addPost(
                title: title,
                content: content,
                categoryID: categoryID,
                images: images
            ) {
                // 서버에서 이미지 처리가 완료될 때까지 잠시 대기
                try? await Task.sleep(nanoseconds: 1_000_000_000)  // 1초 대기
                
                // 게시글 상세 정보를 새로 가져옴
                await postVM.fetchPostDetail(postID: postId)
                
                await MainActor.run {
                    self.newPostId = postId
                    self.navigateToDetail = true
                    dismiss()
                }
            }
        }
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

