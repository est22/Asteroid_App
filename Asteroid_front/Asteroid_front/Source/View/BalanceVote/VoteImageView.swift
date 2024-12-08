import SwiftUI

struct VoteImageView: View {
    let imageName: String
    let onTap: () -> Void

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 150)
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    VoteImageView(imageName: "person"){}
}

