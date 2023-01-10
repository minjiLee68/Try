//
//  FailResponseModek.swift
//  Try
//
//  Created by 이민지 on 2023/01/06.
//

import Foundation

protocol Response: Codable { }

struct FailResponse: Response {
    var code: Int
    var message: String
    var method: String
    var url: String
}
