//
//  UICommons.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

//let mainColor = rgbColor(0xff3498db)
let mainColor = rgbColor(0xffffaf00)
let maleColor = rgbColor(0xff1296db)
let femaleColor = rgbColor(0xffd4237a)

extension UIImageView {
    public class func visualImageView(frame: CGRect, imageName: String?, blurEffectStyle: UIBlurEffectStyle = .light) -> UIImageView {
        let visualImageView = UIImageView()
        if let imageName = imageName {
            visualImageView.image = UIImage(named: imageName)
        }
        visualImageView.frame = frame
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualImageView.addSubview(visualView)
        visualView.snp.makeConstraints { (make) in
            make.edges.equalTo(visualImageView)
        }
        return visualImageView
    }
}

extension UILabel {

    convenience init(bigTitle: String) {
        self.init()
        font = UIFont.systemFont(ofSize: scale(iPhone8Design: 34), weight: .medium)
        textColor = .black
        text = bigTitle
    }
}

extension UIButton {
    public class func customButton(title: String,
                                   size: CGSize = CGSize(width: 280, height: 38),
                                   titleFont: UIFont = UIFont.systemFont(ofSize: scale(iPhone8Design: 15))) -> UIButton {
        let btn = UIButton()
        let normalBg = colorToImage(color: mainColor)
        let highlightBg = colorToImage(color: mainColor.withAlphaComponent(0.8))
        btn.setBackgroundImage(normalBg, for: .normal)
        btn.setBackgroundImage(highlightBg, for: .highlighted)
        btn.setBackgroundImage(highlightBg, for: .selected)
        btn.widthAnchor.constraint(equalToConstant: scale(iPhone8Design: size.width)).isActive = true
        btn.heightAnchor.constraint(equalToConstant: scale(iPhone8Design: size.height)).isActive = true
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = titleFont
        btn.layer.cornerRadius = size.height / 2
        btn.layer.masksToBounds = true
        return btn
    }
    
    public class func iconButton(size: CGSize = CGSize(width: scale(iPhone8Design: 71),
                                                       height: scale(iPhone8Design: 71))) -> UIButton {
        let iconBtn = UIButton()
        iconBtn.setImage(#imageLiteral(resourceName: "ic_add_class"), for: .normal)
        iconBtn.widthAnchor.constraint(equalToConstant: scale(iPhone8Design: size.width)).isActive = true
        iconBtn.heightAnchor.constraint(equalToConstant: scale(iPhone8Design: size.height)).isActive = true
        return iconBtn
    }
}
