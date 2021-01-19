//
//  CommonProblemTableCell.swift
//  WashingMachine
//
//  Created by 郑章海 on 17/3/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommonProblemTableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func create(tableView: UITableView) -> CommonProblemTableCell {
        let reString = NSStringFromClass(self.classForCoder())
        let reuserString = reString.components(separatedBy: ".").last ?? ""
        tableView.register(CommonProblemTableCell.classForCoder(), forCellReuseIdentifier: reuserString)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserString) as! CommonProblemTableCell
        cell.selectionStyle = .none
        return cell
    }

    
    func refreshUI(_ model: QustionModel) {
        self.questionLabel.text = model.title ?? ""
        self.answerLabel.text = model.content ?? ""
    }
    
    fileprivate func makeUI() {
        self.contentView.addSubview(self.questionIcon)
        self.contentView.addSubview(self.answerIcon)
        self.contentView.addSubview(self.questionLabel)
        self.contentView.addSubview(self.answerLabel)

        self.questionIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(16)
            make.width.height.equalTo(18.5)
        }
        self.questionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.questionIcon.snp.right).offset(10)
            make.top.equalTo(self.questionIcon)
            make.right.equalTo(-16)
            make.height.greaterThanOrEqualTo(18.5)
        }
        self.answerIcon.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(self.questionLabel.snp.bottom).offset(10)
            make.width.height.equalTo(18.5)
        }
        self.answerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.answerIcon.snp.right).offset(10)
            make.top.equalTo(self.answerIcon)
            make.bottom.right.equalTo(-16)
            make.height.greaterThanOrEqualTo(18.5)
        }
    }
    
    fileprivate lazy var questionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cm_question")
        return imageView
    }()
    
    fileprivate lazy var answerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cm_answter")
        return imageView
    }()
    
    fileprivate lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = DEEPCOLOR
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = DEEPCOLOR
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
