//
//  UICommons.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

let mainColor = rgbColor(0xff3498db)

extension UILabel {

    convenience init(bigTitle: String) {
        self.init()
        font = UIFont.systemFont(ofSize: scale(iPhone8Design: 34), weight: .medium)
        textColor = .black
        text = bigTitle
    }
}

extension UIButton {
    public class func customButton(title: String) -> UIButton {
        let btn = UIButton()
        btn.widthAnchor.constraint(equalToConstant: scale(iPhone8Design: 280)).isActive = true
        btn.heightAnchor.constraint(equalToConstant: scale(iPhone8Design: 38)).isActive = true
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15))
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 38 / 2
        btn.layer.masksToBounds = true
        return btn
    }
}
