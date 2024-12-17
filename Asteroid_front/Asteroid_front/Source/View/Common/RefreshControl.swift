import SwiftUI

struct RefreshControl: View {
    var coordinateSpace: CoordinateSpace
    var onRefresh: () -> Void
    @State private var refresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: coordinateSpace).midY > 50 {
                Spacer()
                    .onAppear {
                        if !refresh {
                            refresh = true
                            onRefresh()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                refresh = false
                            }
                        }
                    }
            }
            
            HStack {
                Spacer()
                if refresh {
                    ProgressView()
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}