import SwiftUI
 
struct PostWriteView: View {
    @EnvironmentObject var postVM: PostViewModel
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
                        postVM.updatePost(postId: post.id, 
                                         title: title, 
                                         content: content, 
                                         categoryID: post.categoryID,  // 기존 게시물의 categoryID 사용
                                         images: images)
                        dismiss()
                    } else {
                        // 새 글 작성 모드
                        Task {
                            if let categoryID = categoryID,  // 안전하게 옵셔널 바인딩
                               let postId = await postVM.addPost(
                                title: title,
                                content: content,
                                categoryID: categoryID,  // 강제 언래핑 제거
                                images: images
                            ) {
                                self.newPostId = postId
                                self.navigateToDetail = true
                            }
                        }
                    }
                } label: {
                    Text(post != nil ? "수정" : "완료")
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
                    PostDetailView(
                        postID: postId
                    )
                        
                }
            }
        }
    }

}



#Preview {
    let postVM = PostViewModel()
    PostWriteView().environmentObject(postVM)
}

