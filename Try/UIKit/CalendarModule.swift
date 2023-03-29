//
//  CalendarModule.swift
//  Try
//
//  Created by 이민지 on 2023/03/29.
//

import SwiftUI
import FSCalendar

class CalendarModule: UIViewController, FSCalendarDelegate {
    var calendar = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarStyle()
        view.addSubview(calendar)
    }
    
    private func initCalendar() {
        calendar.frame = CGRect(x: 0, y: 0, width: device.screenWidth, height: device.screenWidth)
        calendar.appearance.todayColor = UIColor.systemGreen
        calendar.appearance.selectionColor = UIColor.systemBlue
    }
    
    private func calendarStyle() {
        calendar.locale = Locale(identifier: "en-US")
        calendar.frame = CGRect(x: 0, y: 0, width: device.screenWidth, height: device.screenWidth)
        
        calendar.headerHeight = 66
        calendar.weekdayHeight = 55
        calendar.appearance.headerMinimumDissolvedAlpha = 0.25
        calendar.appearance.headerTitleColor = .secondary
        calendar.appearance.headerDateFormat = "YYYY.MM"
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.borderRadius = 0
        calendar.placeholderType = .none
        
        calendar.appearance.weekdayTextColor = .secondary
        calendar.appearance.selectionColor = .containColor
        calendar.appearance.titleWeekendColor = .secondary
        calendar.appearance.titleDefaultColor = .secondary
        calendar.appearance.borderDefaultColor = .borderColor
        
        calendar.appearance.titleTodayColor = .secondary
        calendar.appearance.todayColor = .none
//        calendar.appearance.weekdayFont = UIFont(name: "Apple Color Emoji", size: 18.0)
    }
}

struct CalendarModuleViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CalendarModuleViewController>) -> UIViewController {
        let viewController = CalendarModule()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CalendarModuleViewController>) {
    
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, FSCalendarDelegate {
        private var parent: CalendarModuleViewController
        
        
        init (_ parent: CalendarModuleViewController) {
            self.parent = parent
        }
        
    }
}
