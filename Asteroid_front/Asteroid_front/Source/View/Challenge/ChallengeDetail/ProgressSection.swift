    import SwiftUI

    struct ProgressSection: View {
        @ObservedObject var viewModel: ChallengeViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(" 내 진행 상황")
                    .font(.system(size: 15, weight: .bold))

                HStack {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            Rectangle()
                                .foregroundColor(.keyColor)
                                .frame(width: geometry.size.width * (CGFloat(viewModel.uploadCount) / CGFloat(viewModel.selectedChallenge?.period ?? 1)), height: 8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.uploadCount)
                        }
                        .cornerRadius(4)
                    }
                    .frame(height: 8)
                    
                    Text("\(viewModel.uploadCount) / \(viewModel.selectedChallenge?.period ?? 0)")
                        .foregroundColor(.keyColor)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    } 