//
//  Constant.swift
//  Try
//
//  Created by 이민지 on 2022/12/28.
//

import SwiftUI

// MARK: 디바이스의 크기, 여백 등의 정보를 담은 struct
// 참고하면 좋은 사이트 : https://kapeli.com/cheat_sheets/iOS_Design.docset/Contents/Resources/Documents/index
struct device {
    // MARK: 노치 디자인인지 아닌지
    static var isNotch: Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        let windows = windowScene.windows
        return Double(windows.first?.safeAreaInsets.bottom ?? -1) > 0
    }

    
    // MARK: 상태바 높이
    static var statusBarHeight: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return 0
        }
        let windows = windowScene.windows
        return windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    // MARK: 네비게이션 바 높이
    static var navigationBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.height
    }
    
    // MARK: 탭 바 높이
    static var tabBarHeight: CGFloat {
        return UITabBarController().tabBar.frame.height
    }
    
    // MARK: 디바이스의 위쪽 여백 (Safe Area 위쪽 여백)
    // ** 위쪽 여백의 전체 높이 : topInset + statusBarHeight + navigationBarHeight(존재하는 경우) **
    static var topInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return 0
        }
        let windows = windowScene.windows
        return windows.first?.safeAreaInsets.top ?? 0
    }
    static var topHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
    
    // MARK: 디바이스의 아래쪽 여백 (Safe Area 아래쪽 여백)
    // ** 아래쪽 여백의 전체 높이 : bottomInset + tabBarHeight(존재하는 경우) **
    static var bottomInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return 0
        }
        let windows = windowScene.windows
        return windows.first?.safeAreaInsets.bottom ?? 0
    }

    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func heightScale(_ size: CGFloat) -> CGFloat {
        return self.isNotch ? UIScreen.main.bounds.height * (size / 812) : UIScreen.main.bounds.height * (size / 667)
        
    }
    
    static func widthScale(_ size: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * (size / 375)
    }
}
