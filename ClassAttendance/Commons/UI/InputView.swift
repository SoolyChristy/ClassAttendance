//
//  InputView.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class InputView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    public class func inputView(placeholderImage: UIImage, placeholderText: String?) -> InputView {
        guard let view = UINib(nibName: "InputView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? InputView else {
            printLog("初始化InputView不成功")
            return InputView()
        }
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.textField.placeholder = placeholderText
        view.iconView.image = placeholderImage
        return view
    }
    
    private init() {
        super.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}
