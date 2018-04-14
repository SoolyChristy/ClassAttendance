//
//  ClassStudentCell.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/3/27.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

protocol ClassStudentCellDelegate: NSObjectProtocol {
    func studentCell(_ cell: ClassStudentCell, didSelectedAttendance type: AttendanceType)
}

class ClassStudentCell: UITableViewCell {
    
    weak var delegate: ClassStudentCellDelegate?
    public var indexPath: IndexPath?
    public var student: Student?
    public var lastPick: AttendanceType?
    
    public func update(model: Student, style: ClassViewController.Style, attendanceType: AttendanceType?, indexPath: IndexPath) {
        self.style = style
        self.indexPath = indexPath
        self.student = model
        setupUI()
        iconView.image = UIImage(named: model.icon)
        nameLabel.text = model.name
        numberLabel.text = "\(model.id)"
        if let attendanceType = attendanceType {
            switch attendanceType {
            case .none:
                absenteeismBtn.isSelected = false
                lateBtn.isSelected = false
                leaveBtn.isSelected = false
            case .absenteeism:
                absenteeismBtn.isSelected = true
                lateBtn.isSelected = false
                leaveBtn.isSelected = false
            case .late:
                lateBtn.isSelected = true
                absenteeismBtn.isSelected = false
                leaveBtn.isSelected = false
            case .leave:
                leaveBtn.isSelected = true
                absenteeismBtn.isSelected = false
                lateBtn.isSelected = false
            }
        }
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
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
        
        if style == .callTheRoll {
            contentView.addSubview(leaveBtn)
            leaveBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(contentView).inset(kBigTitleMargin)
                make.centerY.equalTo(contentView)
                make.height.width.equalTo(scale(iPhone8Design: 28))
            })
            contentView.addSubview(absenteeismBtn)
            absenteeismBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(leaveBtn.snp.left).offset(scale(iPhone8Design: -12))
                make.centerY.equalTo(contentView)
                make.height.width.equalTo(leaveBtn)
            })
            contentView.addSubview(lateBtn)
            lateBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(absenteeismBtn.snp.left).offset(-12)
                make.centerY.equalTo(contentView)
                make.height.width.equalTo(leaveBtn)
            })
        }
    }
    
    private var style: ClassViewController.Style = .normal
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
    
    private lazy var lateBtn: UIButton = {
        let btn = UIButton()
        btn.tag = AttendanceType.late.rawValue
        btn.addTarget(self, action: #selector(functionBtnAction(btn:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "ic_late"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "ic_late_selected"), for: .selected)
        return btn
    }()

    private lazy var absenteeismBtn: UIButton = {
       let btn = UIButton()
        btn.tag = AttendanceType.absenteeism.rawValue
        btn.addTarget(self, action: #selector(functionBtnAction(btn:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "ic_absenteeism"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "ic_absenteeism_selected"), for: .selected)
        return btn
    }()
    
    private lazy var leaveBtn: UIButton = {
       let btn = UIButton()
        btn.tag = AttendanceType.leave.rawValue
        btn.addTarget(self, action: #selector(functionBtnAction(btn:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "ic_leave"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "ic_leave_selected"), for: .selected)
        return btn
    }()
}

extension ClassStudentCell {
    @objc private func functionBtnAction(btn: UIButton) {
        guard var type = AttendanceType(rawValue: btn.tag) else {
            return
        }
        if btn.isSelected {
            type = .none
        }
        btn.isSelected = !btn.isSelected
        switch type {
        case .none:
            absenteeismBtn.isSelected = false
            lateBtn.isSelected = false
            leaveBtn.isSelected = false
        case .absenteeism:
            lateBtn.isSelected = false
            leaveBtn.isSelected = false
        case .late:
            absenteeismBtn.isSelected = false
            leaveBtn.isSelected = false
        case .leave:
            lateBtn.isSelected = false
            absenteeismBtn.isSelected = false
        }
        printLog("\(student?.name ?? "") - 学号:\(student?.id ?? 0) \(type.description)")
        delegate?.studentCell(self, didSelectedAttendance: type)
    }
}
