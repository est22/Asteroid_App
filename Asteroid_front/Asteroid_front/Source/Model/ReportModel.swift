//
//  ReportModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/7/24.
//

import Foundation

struct ReportResponse: Decodable {
    let message: String
    let data: ReportData
}

struct ReportData: Decodable {
    let id: Int
    let reporting_user_id: Int
    let target_user_id: Int
    let target_type: String
    let target_id: Int
    let report_reason: String?
    let report_type: Int
    let updatedAt: String
    let createdAt: String
}
