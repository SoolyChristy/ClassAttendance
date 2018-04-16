//
//  DateUtils.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/16.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation

class DateUtils {
    /// yyyy-MM-dd HH:mm
    public class func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    public class func getWeekDay() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: Date())
        var weekDay = (components.weekday ?? 1) - 1
        if weekDay == 0 {
            weekDay = 7
        }
        return weekDay
    }
}
