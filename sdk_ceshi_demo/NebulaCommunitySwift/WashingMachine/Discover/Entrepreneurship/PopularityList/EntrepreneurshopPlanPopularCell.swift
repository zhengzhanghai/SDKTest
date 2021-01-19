//
//  EntrepreneurshopPlanPopularCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshopPlanPopularCell: EntrepreneurshipPlanCell {

    @discardableResult
    func config(_ plan: EntrepreneurshipPlan, _ indexPath: IndexPath) -> Self {
        super.config(plan)
        
        guard indexPath.row <= 98 else {
            popularView.isHidden = true
            return self
        }
        popularView.isHidden = false
        /// 重新绘制左上角排行角标
        popularView.text = (indexPath.row + 1).stringValue
        popularView.setNeedsDisplay()
        
        return self
    }
    
    override func createUI() {
        super.createUI()
        
        bgView.addSubview(popularView)
        
        bgView.snp.updateConstraints { (make) in
            make.top.equalTo(6.5)
        }
        
        popularView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(41)
        }
    }
    
    lazy var popularView: PopularView = {
        let view = PopularView(frame: CGRect.zero, text: "1")
        return view
    }()

}

extension EntrepreneurshopPlanPopularCell {
    
    class PopularView: UIView {
        
        var text: String
        
        init(frame: CGRect, text: String) {
            self.text = text
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 41, height: 41))
            
            fillColor.set()
            
            path.move(to: CGPoint(x: 0, y: 41))
            path.addLine(to: CGPoint(x: 41, y: 41))
            path.addLine(to: CGPoint(x: 41, y: 0))
            path.close()
            
            path.fill()
            
            // 绘制文字
            (text as NSString).draw(at: CGPoint(x: 6, y: 1),
                                    withAttributes: [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                     NSAttributedString.Key.font : font_PingFangSC_Semibold(text.count >= 2 ? 13 : 18)])
        }
    }
    
}

extension EntrepreneurshopPlanPopularCell.PopularView {
    var fillColor: UIColor {
        switch text {
        case "1":       return UIColor_0x(0xf98424)
        case "2":       return UIColor_0x(0xf7a440)
        case "3":       return UIColor_0x(0xf9c142)
        default:        return UIColor_0x(0xbbbbbb)
        }
    }
}

extension EntrepreneurshopPlanPopularCell {
    enum RankingType {
        case first
        case second
        case third
        case other
    }
}
