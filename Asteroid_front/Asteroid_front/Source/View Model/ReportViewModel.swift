//
//  ReportViewModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/7/24.
//

import Foundation
import Combine
import Alamofire

class ReportViewModel: ObservableObject {
    @Published var selectedReportType: Int? = nil
    @Published var reportReason: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func submitReport(targetType: String, targetId: Int) {
        guard let reportType = selectedReportType else {
            alertMessage = "신고 사유를 선택해주세요."
            showAlert = true
            return
        }
        
        if reportType == 9 && reportReason.isEmpty {
            alertMessage = "기타 사유를 입력해주세요."
            showAlert = true
            return
        }
        
        let parameters: [String: Any] = [
            "target_type": targetType,
            "target_id": targetId,
            "report_type": reportType,
            "report_reason": reportType == 9 ? reportReason : ""
        ]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"
        ]
        
        AF.request("\(APIConstants.baseURL)/report",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseDecodable(of: ReportResponse.self) { [weak self] response in
                switch response.result {
                case .success(let reportResponse):
                    self?.alertMessage = reportResponse.message
                case .failure(let error):
                    self?.alertMessage = "신고에 실패했습니다: \(error.localizedDescription)"
                }
                self?.showAlert = true
            }
    }
}