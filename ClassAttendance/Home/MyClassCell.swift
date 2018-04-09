//
//  MyClassCell.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/9.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

private let kHeight = scale(iPhone8Design: 40)

class MyClassCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(model: Class?, target: UIViewController) {
        aClass = model
        vc = target
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView).inset(kBigTitleMargin)
            make.top.equalTo(contentView).inset(scale(iPhone8Design: 6))
            make.bottom.equalTo(contentView).inset(scale(iPhone8Design: 12))
        }
        let backView = UIImageView.visualImageView(frame: CGRect(), imageName: nil)
        backView.backgroundColor = rgbColor(colors.randomItem ?? 0xffFEA47F)
        container.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalTo(container)
        }
        
        iconView.image = UIImage(named: "ic_defalut_class")
        container.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(container).inset(kBigTitleMargin)
            make.left.equalTo(container).inset(kBigTitleMargin)
            make.height.width.equalTo(scale(iPhone8Design: 42))
        }
        nameLabel.text = "计科1401班"
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14), weight: .medium)
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(scale(iPhone8Design: 12))
            make.top.equalTo(iconView)
        }
        
        lessonLabel.text = "编译原理"
        lessonLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .bold)
        container.addSubview(lessonLabel)
        lessonLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(scale(iPhone8Design: 4))
        }
        
        let startBtn = UIButton.customButton(title: "点名", size: CGSize(width: scale(iPhone8Design: 48), height: scale(iPhone8Design: 28)), titleFont: UIFont.systemFont(ofSize: 13))
        startBtn.addTarget(self, action: #selector(startBtnAction), for: .touchUpInside)
        container.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.right.equalTo(container).inset(kBigTitleMargin)
            make.centerY.equalTo(iconView)
        }
        
        let kMargin = (kScreenWidth - 3 * kHeight - 2 - 2 * kBigTitleMargin) / 6
        
        absenteeismView.countLabel.text = "40"
        absenteeismView.detailLabel.text = "旷课"
        container.addSubview(absenteeismView)
        absenteeismView.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(scale(iPhone8Design: 12))
            make.centerX.equalTo(container)
            make.height.equalTo(kHeight)
            make.width.equalTo(kHeight)
        }
        
        let aSeperator = UIView()
        aSeperator.backgroundColor = .black
        container.addSubview(aSeperator)
        aSeperator.snp.makeConstraints { (make) in
            make.right.equalTo(absenteeismView.snp.left).offset(-kMargin)
            make.centerY.equalTo(absenteeismView)
            make.width.equalTo(1)
            make.height.equalTo(scale(iPhone8Design: 26))
        }
        
        lateView.countLabel.text = "2"
        lateView.detailLabel.text = "迟到"
        container.addSubview(lateView)
        lateView.snp.makeConstraints { (make) in
            make.left.equalTo(container).inset(kMargin)
            make.centerY.equalTo(absenteeismView)
            make.height.equalTo(kHeight)
            make.width.equalTo(kHeight)
        }
        
        let bSeperator = UIView()
        bSeperator.backgroundColor = .black
        container.addSubview(bSeperator)
        bSeperator.snp.makeConstraints { (make) in
            make.left.equalTo(absenteeismView.snp.right).offset(kMargin)
            make.centerY.equalTo(absenteeismView)
            make.width.equalTo(1)
            make.height.equalTo(scale(iPhone8Design: 26))
        }
        
        leaveView.countLabel.text = "3"
        leaveView.detailLabel.text = "请假"
        container.addSubview(leaveView)
        leaveView.snp.makeConstraints { (make) in
            make.left.equalTo(bSeperator.snp.right).offset(kMargin)
            make.centerY.equalTo(absenteeismView)
            make.height.equalTo(kHeight)
            make.width.equalTo(kHeight)
        }
        
    }
    
    private var aClass: Class?
    private weak var vc: UIViewController?
    private let iconView = UIImageView()
    private let lessonLabel = UILabel()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let absenteeismView = AttendenceDataView()
    private let lateView = AttendenceDataView()
    private let leaveView = AttendenceDataView()
    private let container = UIView()
    private let colors: [Int64] = [0xffFEA47F, 0xff25CCF7, 0xffEAB543, 0xff58B19F, 0xff82589F, 0xff6D214F, 0xffBDC581, 0xffee5253, 0xfff368e0, 0xff48dbfb, 0xff576574, 0xfff8a5c2, 0xffc44569, 0xff303952, 0xfffff200, 0xff3d3d3d, 0xff3ae374]
}

extension MyClassCell {
    @objc private func startBtnAction() {
        guard let aClass = aClass else {
            return
        }
        let toVc = ClassViewController(class: aClass, style: .callTheRoll)
        vc?.navigationController?.pushViewController(toVc, animated: true)
    }
}

extension MyClassCell {
    
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

    private func beginAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.25
        animation.toValue = 0.95
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        container.layer.add(animation, forKey: nil)
    }
    
    private func endAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.25
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        container.layer.add(animation, forKey: nil)
    }
}

fileprivate class AttendenceDataView: UIView {

    fileprivate let countLabel = UILabel()
    fileprivate let detailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        countLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 20), weight: .ultraLight)
        addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        detailLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 14))
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countLabel.snp.bottom).offset(scale(iPhone8Design: 2))
            make.centerX.equalTo(self)
        }
    }
}
