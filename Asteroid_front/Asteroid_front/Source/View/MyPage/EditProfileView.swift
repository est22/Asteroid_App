import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @FocusState private var nicknameFieldIsFocused: Bool
    
    // 임시 상태 추가
    @State private var tempNickname: String
    @State private var tempMotto: String
    @State private var tempImage: Image?
    @State private var selectedImageData: Data?
    @State private var showActionSheet = false
    @State private var shouldResetImage: Bool = false  // 기본 이미지로 설정할지 여부
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _tempNickname = State(initialValue: viewModel.nickname)
        _tempMotto = State(initialValue: viewModel.motto)
        
        // MyPage의 프로필 사진으로 초기화
        if let profileImage = viewModel.profileImage {
            _tempImage = State(initialValue: profileImage)
        } else {
            _tempImage = State(initialValue: Image(systemName: "person.circle.fill"))
        }
    }
    
    private var profileImageSection: some View {
        Button(action: {
            showActionSheet = true
        }) {
            ZStack {
                if shouldResetImage {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))
                } else if let tempImage = tempImage {
                    tempImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                cameraButton
            }
        }
        .confirmationDialog("프로필 사진 변경", isPresented: $showActionSheet) {
            Button("앨범에서 사진 선택하기") {
                showImagePicker = true
            }
            
            Button("기본 이미지로 설정하기", role: .destructive) {
                shouldResetImage = true
                tempImage = Image(systemName: "person.circle.fill")
                selectedImageData = nil
            }
            
            Button("취소", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: Binding(
                get: { nil },
                set: { newImage in
                    if let image = newImage {
                        shouldResetImage = false
                        tempImage = Image(uiImage: image)
                        selectedImageData = image.jpegData(compressionQuality: 0.7)
                    }
                }
            ), isPresented: $showImagePicker, sourceType: .photoLibrary)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                profileImageSection
                    .padding(.top, 40)
                
                VStack(spacing: 15) {
                    nicknameField
                    mottoField
                }
                .padding()
                
                Spacer()
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
                            do {
                                // 최종 선택된 이미지 상태를 기준으로 판단
                                if let imageData = selectedImageData {
                                    // 새로운 이미지가 선택됐다면 업로드
                                    await viewModel.uploadProfilePhoto(imageData: imageData)
                                } else {
                                    // 이미지가 없다면 (기본 이미지 상태) 삭제 요청
                                    try await viewModel.deleteProfilePhoto()
                                    viewModel.profileImage = Image(systemName: "person.circle.fill")
                                    viewModel.profilePhoto = nil
                                }
                                
                                // 닉네임과 좌우명 업데이트
                                try await viewModel.updateProfile(nickname: tempNickname, motto: tempMotto)
                                
                                dismiss()
                            } catch {
                                print("프로필 업데이트 실패: \(error)")
                            }
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.isMottoExceeded)
                }
            }
        }
    }
    
    private var cameraButton: some View {
        Image(systemName: "camera.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(Color.keyColor)
            .background(Circle().fill(Color.white))
            .offset(x: 40, y: 40)
    }
    
    private var nicknameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.nickname,
                placeholder: "닉네임",
                isError: !viewModel.profileErrorMessage.isEmpty
            )
            .focused($nicknameFieldIsFocused)
            .onChange(of: viewModel.nickname) { _ in
                viewModel.isNicknameChecked = false
                viewModel.isNicknameAvailable = false
                viewModel.profileErrorMessage = ""
            }
            
            if !viewModel.profileErrorMessage.isEmpty {
                Text(viewModel.profileErrorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 4)
            } else if viewModel.isNicknameChecked && viewModel.isNicknameAvailable {
                Text("사용 가능한 닉네임입니다.")
                    .foregroundColor(Color(UIColor.systemGreen))
                    .font(.caption)
                    .padding(.leading, 4)
            }
        }
    }
    
    private var mottoField: some View {
        VStack(alignment: .leading, spacing: 4) {
            ClearableTextField(
                text: $viewModel.motto,
                placeholder: "소비좌우명",
                isError: viewModel.isMottoExceeded
            )
            .offset(x: viewModel.mottoShakeOffset)
            .onChange(of: viewModel.motto) { newValue in
                if newValue.count > 30 {
                    viewModel.motto = String(newValue.prefix(31))
                    viewModel.isMottoExceeded = true
                } else {
                    viewModel.isMottoExceeded = false
                }
            }
            
            HStack {
                Spacer()
                Text("\(viewModel.motto.count)/30")
                    .font(.caption)
                    .foregroundColor(viewModel.isMottoExceeded ? .red : .gray)
            }
        }
    }
}

#Preview("프로필 수정 화면") {
    let profileViewModel = ProfileViewModel()
    profileViewModel.nickname = "테스트 닉네임"
    profileViewModel.motto = "테스트 좌우명"
    
    return NavigationView {
        EditProfileView(viewModel: profileViewModel)
    }
} 
