import SwiftUI

struct VoteInfoView: View {
    let title: String
    let description: String
    let userName: String
    let profileImageName: String

    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                AsyncImage(url: URL(string: profileImageName)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    case .empty, .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }

                Text(userName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


#Preview {
    VoteInfoView(title: "test", description: "ttttewsdfikjm,erfdcikjnemdfikjenm,sdikje", userName: "test", profileImageName: "person")
}
