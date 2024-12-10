    import SwiftUI

    struct ProgressSection: View {
        var body: some View {
        VStack(alignment: .leading, spacing: 5) {
                                Text("내 진행 상황")
                                    .font(.system(size: 15, weight: .bold))
                                HStack{
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .foregroundColor(.gray.opacity(0.2))
                                                .frame(height: 8)
                                            
                                            Rectangle()
                                                .foregroundColor(.orange)
                                                .frame(width: geometry.size.width * 0.6, height: 8)
                                        }
                                        .cornerRadius(4)
                                    }
                                    .frame(height: 8)
                                    
                                    Text("60%")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 12, weight: .bold))
                                }
                                
                                
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
        }
    } 