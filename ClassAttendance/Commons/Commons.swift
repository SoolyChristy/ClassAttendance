//
//  YCCommons.swift
//  TichomeYC
//
//  Created by SoolyChristina on 2017/12/12.
//  Copyright © 2017年 Mobvoi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Toast_Swift

let kDocumentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let kCachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

let keyWindow = UIApplication.shared.keyWindow

public func scale(iPhone8Design x: CGFloat) -> CGFloat {
  return x * kScale
}

public func rgbColor(_ color: Int64) -> UIColor {
  return UIColor(red: CGFloat((color & 0x00ff0000) >> 16) / 255.0,
                 green: CGFloat((color & 0x0000ff00) >> 8) / 255.0,
                 blue: CGFloat((color & 0x000000ff)) / 255.0,
                 alpha: CGFloat((color & 0xff000000) >> 24) / 255.0)
}

public func randomColor() -> UIColor {
    return rgbColor(colors.randomItem ?? 0xffFEA47F)
}

public func printLog<T>(_ message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line) {
  #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
  #endif
}

public func colorToImage(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}

public func isX() -> Bool {
    if UIScreen.main.bounds.height == 812 {
        return true
    }
    return false
}

public func getWeekDay() -> Int {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.weekday], from: Date())
    var weekDay = (components.weekday ?? 1) - 1
    if weekDay == 0 {
        weekDay = 7
    }
    return weekDay
}

private let kScale = UIScreen.main.bounds.width / 375.0
private let colors: [Int64] = [0xff1abc9c, 0xff2ecc71, 0xff3498db, 0xfff1c40f, 0xfff39c12, 0xffe67e22, 0xffcd84f1, 0xffffcccc, 0xffffb8b8, 0xfffffa65, 0xfffff200, 0xff32ff7e, 0xff67e6dc, 0xff18dcff, 0xff17c0eb, 0xfffc5c65, 0xffeb3b5a, 0xff2bcbba, 0xff0fb9b1, 0xff70a1ff, 0xff2ed573, 0xffff6b81, 0xff70a1ff, 0xffFDA7DF, 0xff12CBC4, 0xffC4E538, 0xff786fa6, 0xff63cdda, 0xffea8685, 0xffe66767]
