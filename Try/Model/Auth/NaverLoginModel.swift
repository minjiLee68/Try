//
//  NaverLoginModel.swift
//  Try
//
//  Created by 이민지 on 2023/01/06.
//

import SwiftUI

// Naver Login Model
struct response_naver_login: Response {
    let resultcode: String
    let message: String
    let response: NaverLoginResponse
}

struct NaverLoginResponse: Codable {
    /// 동일인 식별 정보 - 동일인 식별 정보는 네이버 아이디마다 고유하게 발급되는 값입니다.
    let id: String
    /// 사용자 별명
    let nickname: String?
    /// 사용자 이름
    let name: String?
    /// 사용자 메일 주소
    let email: String
    /// F: 여성 M: 남성 U: 확인불가
    let gender: String?
    /// 사용자 연령대
    let age: String?
    /// 사용자 생일(MM-DD 형식)
    let birthday: String?
    /// 사용자 프로필 사진 URL
    let profile_image: String?
    /// 사용자 출생년도
    let birthyear: String?
}
