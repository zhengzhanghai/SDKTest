

import Foundation
import UIKit


class HZLeftImageButton: UIControl {
    
    fileprivate(set) var normalText: String = ""
    fileprivate(set) var selectedText: String?
    fileprivate(set) var normalImage: UIImage?
    fileprivate(set) var selectedImage: UIImage?
    
    init(imageSize: CGSize, margin: CGFloat) {
        
        super.init(frame: CGRect.zero)
        self.addSubview(icon)
        self.addSubview(textLabel)
        
        icon.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(margin)
            make.centerY.right.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        willSet {
            self.icon.image = newValue ? (self.selectedImage ?? self.normalImage) : self.normalImage
            self.textLabel.text = newValue ? (self.selectedText ?? self.normalText): self.normalText
        }
    }
    
    func setImage(_ image: UIImage?, _ state: UIControl.State) {
        switch state {
        case .normal:
            self.normalImage = image
        case .selected:
            self.selectedImage = image
        default:
            print("")
        }
        
        if isSelected {
            self.icon.image = self.selectedImage ?? self.normalImage
        } else {
            self.icon.image = self.normalImage
        }
    }
    
    func setTitle(_ text: String, _ state: UIControl.State) {
        switch state {
        case .normal:
            self.normalText = text
        case .selected:
            self.selectedText = text
        default:
            print("")
        }
        
        if isSelected {
            self.textLabel.text = self.selectedText ?? self.normalText
        } else {
            self.textLabel.text = self.normalText
        }
    }
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = font_PingFangSC_Regular(13)
        label.textColor = UIColor_0x(0x979797)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
