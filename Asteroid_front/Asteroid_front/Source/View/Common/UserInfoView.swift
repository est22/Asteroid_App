import SwiftUI

struct UserInfoView: View {
  @StateObject private var profileViewModel = ProfileViewModel()
  let profileImageURL: String?
  let nickname: String
  let title: String
  let createdAt: String
  let userID: Int
  var isCurrentUser: Bool
  let onEditTap: () -> Void
  let onDeleteTap: () -> Void
  let onReportTap: () -> Void
  
  // 좋아요
  var likeCount:Int
  @Binding var isLiked: Bool
  
  // post랑 vote 구분
  let option:String
  
  @State private var showingEditView = false
  @State private var navigateToDetail = false
  @State private var newPostId = 0
  let post: Post
  
  @State private var showingDeleteAlert = false
  @EnvironmentObject var postVM: PostViewModel
  @Environment(\.dismiss) var dismiss
  
  // Preview용 샘플 데이터
  static let samplePost = Post(
    id: 1,
    title: "Sample Post Title",
    content: "Sample post content",
    categoryID: 1,
    userID: 1,
    isShow: true,
    likeTotal: 0,
    PostImages: [],
    createdAt: "2024-01-01",
    updatedAt: "2024-01-01",
    commentCount: 0,
    user: nil
  )
  
  var formattedDate: String {
    print("Raw createdAt:", createdAt)  // 디버깅용
    
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = dateFormatter.date(from: createdAt) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd HH:mm"
        return outputFormatter.string(from: date)
    }
    
    // ISO 8601 파싱 실패시 다른 포맷 시도
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    if let date = inputFormatter.date(from: createdAt) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd HH:mm"
        return outputFormatter.string(from: date)
    }
    
    print("Date parsing failed for:", createdAt)  // 디버깅용
    return createdAt  // 파�� 실패시 원본 문자열 반환
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // 프로필 이미지, 닉네임, 날짜, 메뉴 버튼을 한 줄에
      HStack(alignment: .center, spacing: 12) {
        // 프로필 이미지
        if let profileImageURL = profileImageURL, !profileImageURL.isEmpty {
          AsyncImage(url: URL(string: profileImageURL)) { phase in
            switch phase {
            case .empty:
              ProgressView()
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            case .failure:
              Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            @unknown default:
              EmptyView()
            }
          }
        } else {
          Image(systemName: "person.crop.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.gray)
        }
        
        // 닉네임과 날짜
        VStack(alignment: .leading, spacing: 4) {
          Text(nickname)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
          
          Text(formattedDate)
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        Spacer()
        
        // 좋아요 버튼
        if option == "post" {
          Button(action: {
            print("좋아요 클릭")
          }) {
            HStack(spacing: 3) {
              Text("\(likeCount)")
              Image(systemName: isLiked ? "heart.fill" : "heart")
            }
            .foregroundStyle(Color.red.opacity(0.6))
          }
        }
        
        // ... 메뉴 버튼
        Menu {
          if nickname == profileViewModel.nickname {
            if option == "post" {
              Button("수정") {
                showingEditView = true
              }
            }
            Button("삭제", role: .destructive) {
              showingDeleteAlert = true
            }
          } else {
            Button("신고") {
              onReportTap()
            }
            
            // 쪽지 보내기
            NavigationLink(
              destination: MessageListView(chatUser: MessageUser(id: userID, nickname: nickname, profilePhoto: profileImageURL))
            ) {
              Text("쪽지 보내기")
            }
          }
        } label: {
          Image(systemName: "ellipsis")
            .font(.title3)
            .foregroundColor(.black)
        }
      }
      
      // 제목을 별도 라인으로
      Text(title)
        .font(.title3)
        .fontWeight(.bold)
        .foregroundColor(.primary)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity)
    .task {
      try? await profileViewModel.fetchProfile()
    }
    .navigationDestination(isPresented: $showingEditView) {
      PostWriteView(categoryID: post.categoryID, post: post)
    }
    .alert("게시글 삭제", isPresented: $showingDeleteAlert) {
      Button("취소", role: .cancel) { }
      Button("삭제", role: .destructive) {
        postVM.deletePost(postId: post.id)
        dismiss()
      }
    } message: {
      Text("게시글을 정말로 삭제하시겠습니까?")
    }
  }
}

#Preview {
  UserInfoView(
    profileImageURL: "https://via.placeholder.com/100",
    nickname: "JohnDoe",
    title: "Sample Post Title",
    createdAt: "2024-12-16T16:46:00Z",
    userID: 1,
    isCurrentUser: true,
    onEditTap: {},
    onDeleteTap: {},
    onReportTap: {},
    likeCount: 1,
    isLiked: .constant(true),
    option: "post",
    post: UserInfoView.samplePost
  )
}
