//
//  UploadService.swift
//  Try
//
//  Created by 이민지 on 2022/12/30.
//

import SwiftUI

class UploadService {
    static func uploadImage(image: UIImage, completion: @escaping () -> Void) {
        print("[Log_upload] Trc 33 image: \(image)")
        let path = "file/m3u8"
        var multiForm = MultipartFormData()
        
        let imageData = image.jpegData(compressionQuality: 0.1)
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            multiForm.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
            }
        
        print("[Log_upload] Trc 333")
        UrlComponents.upload(formData: multiForm, path: path, type: UploadResponse.self) { res in
            print("[Log_upload] Trc 3333  \(res)")
      
            completion(res)
        }
    }
}
