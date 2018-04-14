//
//  AnimationCell.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class AnimationCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView).inset(kBigTitleMargin)
            make.top.equalTo(contentView).inset(scale(iPhone8Design: 6))
            make.bottom.equalTo(contentView).inset(scale(iPhone8Design: 12))
        }
    }

    var animationView: UIView {
        return container
    }
    var container = UIView()
}

extension AnimationCell: CellAnimation {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        beginAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAnimation()
    }
}

