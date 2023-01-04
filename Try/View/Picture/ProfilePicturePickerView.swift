//
//  ProfilePicturePickerView.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI
import Foundation
import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos
import AssetsLibrary


struct ProfilePicturePickerView : UIViewControllerRepresentable {
    
    @Binding var imageUpload: UIImage
    @Binding var isImageChanged: Bool
    
    func makeUIViewController(context: Context) -> YPImagePicker {
        
        var config = YPImagePickerConfiguration()
        
        
        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */
        
        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
        
        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
        config.onlySquareImagesFromCamera = false

        
        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
         resized to fit in a 1024x1024 box. Defaults to original image size. */
        //        config.targetImageSize = .cappedTo(size: 1024)
        
        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photo
        config.library.itemOverlayType = .grid
        config.library.preSelectItemOnMultipleSelection = false
        config.library.defaultMultipleSelection = false
//        config.library.onlySquare = true
        config.library.isSquareByDefault = false
//        config.onlySquareImagesFromCamera = false
        
        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
//        config.usesFrontCamera = true
        
        /* Adds a Filter step in the photo taking process. Defaults to true */
         config.showsPhotoFilters = false
        
        
        /* Manage filters by yourself */
        // config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
        //                   YPFilter(name: "Normal", coreImageFilterName: "")]
        // config.filters.remove(at: 1)
        //         config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)
        
        /* Enables you to opt out from saving new (or old but filtered) images to the
         user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = true
        
        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        //사이즈 설정
//        config.video.fileType = .mp4
//        config.video.compression = AVAssetExportPreset1920x1080
        
        
        /* Choose the recordingSizeLimit. If not setted, then limit is by time. */
        // config.video.recordingSizeLimit = 10000000
        
        /* Defines the name of the album when saving pictures in the user's photo library.
         In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        // config.albumName = "ThisIsMyAlbum"
        
        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
         Default value is `.photo` */
        config.startOnScreen = .library
        
        /* Defines which screens are shown at launch, and their order.
         Default value is `[.library, .photo]` */
        config.screens = [.library, .photo]
        
        /* Can forbid the items with very big height with this property */
        // config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8
        
        /* Defines the time limit for recording videos.
         Default is 30 seconds. */
//        config.video.recordingTimeLimit = 30
        
        
        /* Defines the time limit for videos from the library.
         Defaults to 60 seconds. */
//        config.video.libraryTimeLimit = .infinity
//        config.video.trimmerMinDuration = 10
//        config.video.trimmerMaxDuration = 30
        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
        //        config.showsCrop = .rectangle(ratio: (16/9))
        
        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView
        
        /* Customize wordings */
        config.wordings.libraryTitle = "사진첩"
        config.wordings.albumsTitle = "사진첩"
        config.wordings.videoTitle = "영상"
        config.wordings.cancel = "취소"
        config.wordings.next = "확인"
        config.wordings.trim = "짜르기"
        config.wordings.cover = "썸네일"
        
        config.library.options?.wantsIncrementalChangeDetails = false
        
        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = true
        
        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false
        //
        config.maxCameraZoomFactor = 1.0
        config.library.preSelectItemOnMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.gallery.hidesRemoveButton = true
        
        
        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
        // config.library.minNumberOfItems = 2
        
        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true
        
        /* Here we use a per picker configuration. Configuration is always shared.
         That means than when you create one picker with configuration, than you can create other picker with just
         let picker = YPImagePicker() and the configuration will be the same as the first picker. */
        
        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        // options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options
        
        //        config.library.preselectedItems = selectedItems
        
        let picker = YPImagePicker(configuration: config)
        picker.imagePickerDelegate = context.coordinator
        
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                
                self.imageUpload = photo.image
                self.isImageChanged = true
            }
            picker.dismiss(animated: true, completion: nil)
        }
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return ProfilePicturePickerView.Coordinator(parent: self)
        
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {
        
    }
    //
    
    class Coordinator: NSObject , YPImagePickerDelegate, AVCaptureFileOutputRecordingDelegate {
        func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
            
        }
        
        func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
            return true
        }
        
        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) { }
        
        //부모 뷰 쪽이랑 연결 (Delegate를 위해)
        var parent: ProfilePicturePickerView
        
        init(parent: ProfilePicturePickerView){
            self.parent = parent
        }
    }
}
