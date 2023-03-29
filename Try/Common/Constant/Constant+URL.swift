//
//  Constant+URL.swift
//  Try
//
//  Created by 이민지 on 2023/01/06.
//

import SwiftUI
import UIKit
import Foundation
import Combine
import Alamofire

struct UrlComponents {
    static private let successRange = 200 ..< 300
    static private let failRange = 400 ..< 500
    
    //    Request Method 중 Post, Put, Delete에서 결과값으로 확인하는 result
    public enum result {
        case success
        case fail
    }
    
    static func checkRange(range: Int) -> result {
        if successRange.contains(range) {
            return .success
        } else if failRange.contains(range) {
            return .fail
        } else {
            return .fail
        }
    }
    
    static func parsingJson<R: Response> (response: AFDataResponse<Any>, type: R.Type, completion: @escaping (Response?) -> Void) {
        switch response.result {
            case .success(let res):
                let range = response.response?.statusCode ?? 400
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let isSuccess = UrlComponents.checkRange(range: range)
                    var json: Response? = nil
                    
                    switch isSuccess {
                        case .success:
                            json = try JSONDecoder().decode(type, from: jsonData)
                        case .fail:
                            json = try JSONDecoder().decode(FailResponse.self, from: jsonData)
                    }
                    completion(json)
                    
                } catch(let e) {
                    print("Service Parsing Error After Success Response \(e.localizedDescription)")
                    completion(nil)
                }
                
            case .failure(let e):
                print("Serivce Connection Error After Fail Response\(e.localizedDescription)")
                completion(nil)
                return
        }
    }
}

extension UIColor {
    class var primary: UIColor? { return UIColor(named: "primary") }
    class var secondary: UIColor? { return UIColor(named: "secondary") }
    class var containColor: UIColor? { return UIColor(named: "containerColor") }
    class var check1Color: UIColor? { return UIColor(named: "check1")}
    class var check2Color: UIColor? { return UIColor(named: "check2")}
    class var check3Color: UIColor? { return UIColor(named: "check3")}
    class var borderColor: UIColor? { return UIColor(named: "borderColor")}
    
}
