//
//  LoginService.swift
//  Try
//
//  Created by 이민지 on 2023/01/06.
//

import Foundation
import Alamofire
import Firebase

class LoginService {
    static func naverLogin<R: Response>(authorization: String, type: R.Type, completion: @escaping (Response?) -> Void) {
        let requestURL = URLComponents(string: "https://openapi.naver.com/v1/nid/me")!
        
        
        let headers: HTTPHeaders = ["Authorization": authorization]
        
        AF.request(requestURL, method: .get, headers: headers)
            .responseJSON { response in
                UrlComponents.parsingJson(response: response, type: type) { json in
                    completion(json)
                }
            }
    }
}
