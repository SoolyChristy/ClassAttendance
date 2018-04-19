//
//  MyAttendanceController.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/16.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import UIKit

private let kReuseId = "attendance.cell.id"

class MyAttendanceController: BaseViewController {

    enum Style {
        case single
        case all
    }
    
    init(record: AttendanceRecord, style: Style = .single) {
        self.style = style
        self.record = record
        self.absenteeismStudents = StudentManager.shared.get(with: record.absenteeism)
        self.lateStudents = StudentManager.shared.get(with: record.late)
        self.leaveStudents = StudentManager.shared.get(with: record.leave)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: Int {
        case absenteeism = 0
        case late
        case leave
        case max
        
        func title() -> String {
            switch self {
            case .absenteeism:
                return "旷课"
            case .late:
                return "迟到"
            case .leave:
                return "请假"
            default:
                return ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "考勤表"
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scale(iPhone8Design: 96))
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 22), weight: .bold)
        nameLabel.text = record.className + record.lessonName
        header.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(header).inset(kBigTitleMargin)
            make.top.equalTo(header).inset(kBigTitleMargin)
        }
        let dateLabel = UILabel()
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .light)
        dateLabel.text = DateUtils.dateToString(date: record.date)
        header.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(scale(iPhone8Design: 4))
        }
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 15), weight: .light)
        detailLabel.text = "旷课\(absenteeismStudents.count)人 迟到\(lateStudents.count)人 请假\(leaveStudents.count)人"
        header.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(scale(iPhone8Design: 4))
        }
        tableView.tableHeaderView = header
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        tableView.register(ClassStudentCell.self, forCellReuseIdentifier: kReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = scale(iPhone8Design: 60)
        tableView.tableFooterView = UIView()
    }
    
    private let style: Style
    private let record: AttendanceRecord
    private let absenteeismStudents: [Student]
    private let lateStudents: [Student]
    private let leaveStudents: [Student]
    private let tableView = UITableView()

}

extension MyAttendanceController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) ?? .max {
        case .absenteeism:
            return absenteeismStudents.count
        case .late:
            return lateStudents.count
        case .leave:
            return leaveStudents.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseId, for: indexPath) as! ClassStudentCell
        switch Section(rawValue: indexPath.section) ?? .max {
        case .absenteeism:
            cell.update(model: absenteeismStudents[indexPath.row], style: .normal, attendanceType: nil, indexPath: indexPath)
        case .late:
            cell.update(model: lateStudents[indexPath.row], style: .normal, attendanceType: nil, indexPath: indexPath)
        case .leave:
            cell.update(model: leaveStudents[indexPath.row], style: .normal, attendanceType: nil, indexPath: indexPath)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Section(rawValue: section) ?? .max {
        case .absenteeism:
            if absenteeismStudents.count == 0 {
                return UIView()
            }
        case .late:
            if lateStudents.count == 0 {
                return UIView()
            }
        case .leave:
            if leaveStudents.count == 0 {
                return UIView()
            }
        default:
            break
        }
        let view = UIView()
        view.backgroundColor = tableView.backgroundColor
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scale(iPhone8Design: 40))
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 18), weight: .medium)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view).inset(kBigTitleMargin)
            make.centerY.equalTo(view)
        }
        let section = Section(rawValue: section) ?? .max
        label.text = section.title()
        return view
    }
}
