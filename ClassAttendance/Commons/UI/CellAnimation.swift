//
//  CellAnimation.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

protocol CellAnimation where Self: UITableViewCell {
    var animationView: UIView { get }
    func beginAnimation()
    func endAnimation()
}

extension CellAnimation {
    var animationView: UIView {
        return contentView
    }
    
    func beginAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.25
        animation.toValue = 0.9
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animationView.layer.add(animation, forKey: nil)
    }
    
    func endAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.25
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animationView.layer.add(animation, forKey: nil)
    }
}
