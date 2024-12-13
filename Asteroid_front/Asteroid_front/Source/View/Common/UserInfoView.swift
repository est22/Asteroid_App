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
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    case .failure:
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }

            // 제목, 닉네임
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .bold()

                Text(nickname)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // 오른쪽 ... 버튼
            Button {
                print("버튼")
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            .padding(.trailing, 8)
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
