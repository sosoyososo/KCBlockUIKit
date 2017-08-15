//
//  KCTips.swift
//  KCBlockUIKit
//
//  Created by karsa on 2017/8/15.
//  Copyright © 2017年 karsa. All rights reserved.
//

import UIKit

open class KCTips {
    
    public enum Position {
        case center, bottom, top
    }
    
    private let masks = UIView()
    public class func showtipsing(with tips : String,
                                  inView : UIView,
                                  position : Position = .center,
                                  inset : Float = 20) -> KCTips {
        let kctips = KCTips()
        kctips.masks.backgroundColor = UIColor.clear
        
        inView.addSubview(kctips.masks)
        kctips.masks.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let label = UILabel()
        label.updateWithConfigData(["text":tips,
                                    "textAlignment":NSTextAlignment.center.rawValue,
                                    "textColor":UIColor.white,
                                    "backgroundColor":UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.65),
                                    "font":UIFont.systemFont(ofSize: 12),
                                    "layer.masksToBounds":true,
                                    "layer.cornerRadius":4,
                                    "numberOfLines":0])
        kctips.masks.addSubview(label)
        
        let attr = NSMutableAttributedString.init(string: tips)
        attr.addAttributes([NSFontAttributeName:label.font], range: NSMakeRange(0, attr.length))
        let rect = attr.boundingRect(with: CGSize.init(width: inView.width - 30, height: 1000), options: .usesLineFragmentOrigin, context: nil)
        let height = min(rect.height, inView.height - CGFloat(2*inset))
        let width = min(rect.width, inView.width - 30)
        label.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: height))
            make.centerX.equalToSuperview()
            if position == .center {
                make.centerY.equalToSuperview()
            } else if position == .bottom {
                make.bottom.equalToSuperview().inset(inset)
            } else {
                make.top.equalToSuperview().inset(inset)
            }
        }
        
        return kctips
    }
    
    public func hide() {
        masks.removeFromSuperview()
    }
    
}
