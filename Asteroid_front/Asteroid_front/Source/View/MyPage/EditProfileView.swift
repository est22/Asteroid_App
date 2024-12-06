import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditProfileViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @FocusState private var nicknameFieldIsFocused: Bool
    
    init(profileViewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(profileViewModel: profileViewModel))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                profilePhotoSection
                nicknameSection
                mottoSection
            }
            .padding()
            .navigationTitle("프로필 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        Task {
                            if !profileViewModel.isNicknameChecked {
                                await profileViewModel.checkNicknameAvailability(viewModel.nickname)
                            }
                            
                            if profileViewModel.isNicknameAvailable && !viewModel.isMottoExceeded {
                                do {
                                    try await viewModel.updateProfile()
                                    dismiss()
                                } catch {
                                    print("프로필 업데이트 실패: \(error)")
                                }
                            }
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.isMottoExceeded)
                }
            }
        }
    }
    
    // MARK: - View Components
    private var profilePhotoSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            profileImageView
        }
        .onChange(of: selectedItem, perform: handleImageSelection)
    }
    
    private var profileImageView: some View {
        ZStack {
            if let profileImage = viewModel.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }
            
            cameraButton
        }
    }
    
    private var cameraButton: some View {
        Image(systemName: "camera.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .background(Circle().fill(Color.keyColor))
            .offset(x: 40, y: 40)
    }
    
    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.nickname,
                placeholder: "닉네임",
                isError: !profileViewModel.profileErrorMessage.isEmpty
            )
            .focused($nicknameFieldIsFocused)
            .onChange(of: viewModel.nickname) { _ in
                profileViewModel.isNicknameChecked = false
                profileViewModel.isNicknameAvailable = false
                profileViewModel.profileErrorMessage = ""
            }
            
            if !profileViewModel.profileErrorMessage.isEmpty {
                Text(profileViewModel.profileErrorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 4)
            } else if profileViewModel.isNicknameChecked && profileViewModel.isNicknameAvailable {
                Text("사용 가능한 닉네임입니다.")
                    .foregroundColor(Color(UIColor.systemGreen))
                    .font(.caption)
                    .padding(.leading, 4)
            }
        }
    }
    
    private var mottoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.motto,
                placeholder: "소비좌우명",
                isError: viewModel.isMottoExceeded
            )
            .offset(x: viewModel.mottoShakeOffset)
            .onChange(of: viewModel.motto) { newValue in
                viewModel.validateMotto(newValue)
            }
            
            HStack {
                Spacer()
                Text("\(viewModel.motto.count)/30")
                    .font(.caption)
                    .foregroundColor(viewModel.isMottoExceeded ? .red : .gray)
            }
        }
    }
    
    private func handleImageSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                viewModel.profileImage = Image(uiImage: uiImage)
                
                if let compressedData = uiImage.jpegData(compressionQuality: 0.7) {
                    await profileViewModel.uploadProfilePhoto(imageData: compressedData)
                }
            }
        }
    }
} 