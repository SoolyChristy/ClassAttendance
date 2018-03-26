//
//  TextFiledView.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/20.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

final class TextFiledView: UIView {

    public var text: String? {
        get {
            return textFiled.text
        }
        set {
            textFiled.text = text
        }
    }
    
    public var font: UIFont? {
        get {
            return textFiled.font
        }
        set {
            textFiled.font = font
        }
    }
    
    public var seperatorColor: UIColor? {
        get {
            return seperator.backgroundColor
        }
        set {
            seperator.backgroundColor = seperatorColor
        }
    }
    
    @IBOutlet weak var placehoderLabel: UILabel!
    
    public class func textFiledView() -> TextFiledView {
        guard let view = UINib(nibName: "TextFiledView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? TextFiledView else {
            printLog("初始化TextFiledView不成功")
            return TextFiledView()
        }
        view.setupUI()
        return view
    }
    
    public func setStatusDidChanged<T: AnyObject>(_ target: T, handler: ((T, _ text: String) -> ())?) {
        statusDidChanged = { [weak target] text in
            guard let target = target else {
                return
            }
            handler?(target, text)
        }
    }
    
    private init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet private weak var textFiled: UITextField!
    @IBOutlet private weak var seperator: UIView!
    private var statusDidChanged: ((_ text: String) -> ())?
}

extension TextFiledView {
    private func setupUI() {
        textFiled.delegate = self
        textFiled.returnKeyType = .done
        textFiled.textAlignment = .center
        textFiled.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 16))
        textFiled.addTarget(self, action: #selector(textFiledStatusChanged), for: .editingChanged)
        seperator.backgroundColor = mainColor
    }
    
    @objc private func textFiledStatusChanged() {
        placehoderLabel.isHidden = (textFiled.text ?? "").isEmpty ? false : true
        statusDidChanged?(textFiled.text ?? "")
    }
}

extension TextFiledView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
