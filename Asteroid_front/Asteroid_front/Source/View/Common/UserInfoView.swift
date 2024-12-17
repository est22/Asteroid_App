import SwiftUI

struct UserInfoView: View {
  let profileImageURL: String?
  let nickname: String
  let title: String
  
  var body: some View {
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
      
      // 제목, 닉네임
      VStack(alignment: .leading, spacing: 1) {
        Text(title)
           .font(.subheadline)
           .fontWeight(.semibold)
          .foregroundStyle(.primary)
          .foregroundColor(.black)
          .lineLimit(1)
        
        Text(nickname)
          .font(.footnote)
          .foregroundColor(.gray)
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  UserInfoView(
    profileImageURL: "https://via.placeholder.com/100",
    nickname: "JohnDoe",
    title: "Sample Post Title"
  )
}
