//
//  ClassStudentCell.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/27.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class ClassStudentCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(model: Student) {
        iconView.image = UIImage(named: model.name)
        nameLabel.text = model.name
        numberLabel.text = "\(model.id)"
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        iconView.backgroundColor = .yellow
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(scale(iPhone8Design: 16))
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(scale(iPhone8Design: 36))
        }
        
        nameLabel.text = "罗建武"
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(scale(iPhone8Design: 16))
            make.bottom.equalTo(contentView.snp.centerY).offset(scale(iPhone8Design: -2))
        }
        
        numberLabel.text = "201421091024"
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(contentView.snp.centerY).offset(scale(iPhone8Design: 2))
        }
    }
    
    private let iconView = UIImageView()
    private let nameLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .light)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let numberLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .light)
        $0.textColor = UIColor.black.withAlphaComponent(0.8)
        return $0
    }(UILabel())

}
