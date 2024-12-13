import SwiftUI

@MainActor
class EditProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var nickname: String
    @Published var motto: String
    @Published var profileImage: Image?
    @Published var isLoading: Bool = false
    @Published var mottoShakeOffset: CGFloat = 0
    @Published var isMottoExceeded: Bool = false
    
    // MARK: - Private Properties
    private let profileViewModel: ProfileViewModel
    
    // MARK: - Initialization
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        self.nickname = profileViewModel.nickname
        self.motto = profileViewModel.motto
    }
    
    // MARK: - Methods
    func validateMotto(_ newValue: String) {
        if newValue.count > 30 {
            isMottoExceeded = true
            motto = String(newValue.prefix(31))
            shakeMottoField()
        } else {
            isMottoExceeded = false
        }
    }
    
    private func shakeMottoField() {
        withAnimation(.default) {
            mottoShakeOffset = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default) {
                self.mottoShakeOffset = -10
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.default) {
                self.mottoShakeOffset = 0
            }
        }
    }
    
    func updateProfile() async throws {
        isLoading = true
        do {
            try await profileViewModel.updateProfile(nickname: nickname, motto: motto)
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }
} 