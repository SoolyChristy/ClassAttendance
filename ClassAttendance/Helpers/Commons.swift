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

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

public func scale(iPhone8Design x: CGFloat) -> CGFloat {
  return x * kScale
}

public func rgbColor(_ color: Int64) -> UIColor {
  return UIColor(red: CGFloat((color & 0x00ff0000) >> 16) / 255.0,
                 green: CGFloat((color & 0x0000ff00) >> 8) / 255.0,
                 blue: CGFloat((color & 0x000000ff)) / 255.0,
                 alpha: CGFloat((color & 0xff000000) >> 24) / 255.0)
}

public func printLog<T>(_ message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line) {
  #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
  #endif
}

private let kScale = UIScreen.main.bounds.width / 375.0
