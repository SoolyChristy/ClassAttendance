//
//  ClassTimeManager.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/26.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import UIKit

final class ClassTimeManager {
    
    struct ClassTime {
        var week: String
        var date: String
    }
    
    typealias Compeletion = (_ date: ClassDate) -> ()
    private let weeks = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    /// return (week, date)
    public func classDateToString(classDate: ClassDate) -> ClassTime {
        var weekString = ""
        var dateString = ""
        for (week, date) in classDate {
            if week <= weeks.count {
                weekString = weeks[week - 1]
            }
            dateString = dateFormate.string(from: date)
        }
        return ClassTime(week: weekString, date: dateString)
    }
    
    public func classDatesToString(classDates: [ClassDate]) -> String {
        var str = ""
        for classDate in classDates {
            let classTime = classDateToString(classDate: classDate)
            str += "\(classTime.week) \(classTime.date)/"
        }
        guard !str.isEmpty else {
            return str
        }
        str.removeLast()
        return str
    }
    
    public func showClassTimePicker(defaultClassDate: ClassDate? = nil, compeletion: @escaping Compeletion) {
        handler = compeletion
        self.defaultClassDate = defaultClassDate
        showWeekPicker()
    }
    
    private func showWeekPicker() {
        weekAlert.show()
    }
    
    private func showTimePicker() {
        timeAlert.show()
    }
    
    private var selectedWeek: String?
    private var selectedDate: Date?
    private var defaultClassDate: ClassDate?
    private lazy var dateFormate: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    private lazy var weekAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "请选择上课时间", preferredStyle: .actionSheet)
        var index: PickerViewViewController.Index?
        if let classDate = defaultClassDate {
            for (week, _) in classDate {
                index = (0, week - 1)
            }
        }
        alert.addPickerView(values: [weeks], initialSelection: index, action: { [weak self] (_, _, index, _) in
            self?.selectedWeek = self?.weeks[index.row]
            self?.timeAlert.title = self?.selectedWeek
        })
        alert.addAction(title: "下一步", style: .default) { [weak self] ( _) in
            printLog("下一步")
            self?.showTimePicker()
        }
        alert.addAction(title: "取消", style: .cancel)
        return alert
    }()
    
    private lazy var timeAlert: UIAlertController = {
        let alert = UIAlertController(title: selectedWeek, message: "请选择课堂开始时间", preferredStyle: .actionSheet)
        var defaultDate: Date?
        if let classDate = defaultClassDate {
            for (_, date) in classDate {
                defaultDate = date
            }
        }
        alert.addDatePicker(mode: .time, date: defaultDate) { [weak self] (date) in
            self?.selectedDate = date
        }
        alert.addAction(title: "上一步", style: .default) { [weak self] ( _) in
            printLog("上一步")
            self?.showWeekPicker()
        }
        alert.addAction(title: "完成", style: .cancel) { [weak self] ( _) in
            if let classDate = self?.classDate() {
                printLog("选择时间完成 - \(classDate)")
                self?.handler(classDate)
            }
        }
        return alert
    }()
    
    private var handler: Compeletion = {_ in }
}

extension ClassTimeManager {
    private func classDate() -> ClassDate {
        
        if let classDate = defaultClassDate,
            selectedWeek == nil {
            for week in classDate.keys {
                return [week: selectedDate ?? Date()]
            }
        }
        if selectedWeek == nil {
            selectedWeek = "周一"
        }
        
        guard let selectedWeek = selectedWeek,
            let date = selectedDate else {
                return [:]
        }
        for (i, week) in weeks.enumerated() {
            if week == selectedWeek {
                return [i + 1 : date]
            }
        }
        return [1: date]
    }
}
