//
//  AttendanceRecordCell.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/14.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

class AttendanceRecordCell: AnimationCell {
    
    public func update(model: AttendanceRecord) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = dateFormatter.string(from: model.date)
        classLabel.text = "班级: \(model.className)"
        lessonLabel.text = "课程: \(model.lessonName)"
        lateView.textLabel.text = "\(model.late.count)"
        absenteeismView.textLabel.text = "\(model.absenteeism.count)"
        leaveView.textLabel.text = "\(model.leave.count)"
    }
    
    override func setupUI() {
        super.setupUI()
//        container.backgroundColor = randomColor()
        dateLabel.textColor = .darkGray
        dateLabel.text = "2018年5月12日 11:30"
        dateLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14), weight: .medium)
        container.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(container).inset(scale(iPhone8Design: 6))
            make.top.equalTo(container).inset(scale(iPhone8Design: 6))
        }
        classLabel.text = "班级: 计科1401"
        classLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .medium)
        container.addSubview(classLabel)
        classLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(scale(iPhone8Design: 4))
            make.left.equalTo(dateLabel)
        }
        lessonLabel.text = "编译原理"
        lessonLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .medium)
        container.addSubview(lessonLabel)
        lessonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(classLabel.snp.bottom).offset(scale(iPhone8Design: 4))
            make.left.equalTo(dateLabel)
        }
        
        leaveView.iconView.image = #imageLiteral(resourceName: "ic_leave_selected")
        container.addSubview(leaveView)
        leaveView.snp.makeConstraints { (make) in
            make.right.equalTo(container.snp.right).inset(scale(iPhone8Design: 6))
            make.centerY.equalTo(container)
            make.width.equalTo(scale(iPhone8Design: 30))
            make.height.equalTo(scale(iPhone8Design: 45))
        }

        absenteeismView.iconView.image = #imageLiteral(resourceName: "ic_absenteeism_selected")
        container.addSubview(absenteeismView)
        absenteeismView.snp.makeConstraints { (make) in
            make.right.equalTo(leaveView.snp.left).offset(scale(iPhone8Design: -12))
            make.height.width.equalTo(leaveView)
            make.centerY.equalTo(leaveView)
        }

        lateView.iconView.image = #imageLiteral(resourceName: "ic_late_selected")
        container.addSubview(lateView)
        lateView.snp.makeConstraints { (make) in
            make.right.equalTo(absenteeismView.snp.left).offset(scale(iPhone8Design: -12))
            make.height.width.equalTo(leaveView)
            make.centerY.equalTo(leaveView)
        }
        
        let seperator = UIView()
        seperator.backgroundColor = .lightGray
        contentView.addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).inset(0)
            make.centerX.equalTo(contentView)
            make.height.equalTo(0.5)
            make.width.equalTo(container)
        }
    }
    
    private let dateLabel = UILabel()
    private let classLabel = UILabel()
    private let lessonLabel = UILabel()
    private let absenteeismView = AttendanceDetailView()
    private let leaveView = AttendanceDetailView()
    private let lateView = AttendanceDetailView()
}

fileprivate class AttendanceDetailView: UIView {
    let textLabel = UILabel()
    let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.height.equalTo(scale(iPhone8Design: 28))
        }
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15))
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(scale(iPhone8Design: 4))
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
