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

private let kScale = UIScreen.main.bounds.width / 375.0
private let colors: [Int64] = [0xffFEA47F, 0xff25CCF7, 0xffEAB543, 0xff58B19F, 0xff82589F, 0xff6D214F, 0xffBDC581, 0xffee5253, 0xfff368e0, 0xff48dbfb, 0xff576574, 0xfff8a5c2, 0xffc44569, 0xff303952, 0xfffff200, 0xff3d3d3d, 0xff3ae374]
