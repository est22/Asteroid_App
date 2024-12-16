import SwiftUI

import SwiftUI

struct VoteImageView: View {
    let imageURL: String
    let onTap: () -> Void

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
              case .empty:
                  ProgressView()
                      .frame(height: 150)
              case .success(let image):
                  image
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .clipped()
                      .onTapGesture {
                          onTap()
                      }
              case .failure:
                  Image(systemName: "photo")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(height: 150)
                      .clipped()
                      .foregroundColor(.gray)
              @unknown default:
                  Image(systemName: "photo")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(height: 150)
                      .foregroundColor(.gray)
              }
        }
    }
}

#Preview {
    VoteImageView(imageURL: "https://via.placeholder.com/150") {
        print("Image tapped")
    }
}


