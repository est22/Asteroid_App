//
//  ReportView.swift
//  Asteroid_front
//
//  Created by Lia An on 12/7/24.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel = ReportViewModel()
    let targetType: String
    let targetId: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("신고 사유를 선택하세요")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .padding(.horizontal)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 5) {
                        ForEach(0..<10, id: \.self) { index in
                            HStack {
                                Image(systemName: viewModel.selectedReportType == index ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.selectedReportType == index ? Color.color1 : .gray)
                                    .imageScale(.large)
                                
                                Text(reportReason(for: index))
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                            .padding(10)
                            .background(viewModel.selectedReportType == index ? Color.color1.opacity(0.1) : Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedReportType = index
                                }
                            }
                        }

                        if viewModel.selectedReportType == 9 {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("상세 사유를 입력해주세요")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                TextEditor(text: $viewModel.reportReason)
                                    .frame(height: 100)
                                    .padding(10)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    viewModel.submitReport(targetType: targetType, targetId: targetId)
                }) {
                    Text("신고하기")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.color1)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("확인")) {
                            if viewModel.alertMessage == "신고가 성공적으로 접수되었습니다." {
                                dismiss()
                            }
                        }
                    )
                }
            }
            .navigationTitle("신고 접수하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func reportReason(for index: Int) -> String {
        switch index {
        case 0: return "스팸홍보/도배입니다."
        case 1: return "음란물입니다."
        case 2: return "불법정보를 포함하고 있습니다."
        case 3: return "청소년에게 유해한 내용입니다."
        case 4: return "욕설/생명경시/혐오/차별적 표현입니다."
        case 5: return "개인정보가 노출되었습니다."
        case 6: return "불쾌한 표현이 있습니다."
        case 7: return "명예훼손 또는 저작권이 침해되었습니다."
        case 8: return "불법촬영물이 포함되어 있습니다."
        case 9: return "기타"
        default: return ""
        }
    }
}

#Preview {
    ReportView(targetType: "C", targetId: 1)
}
