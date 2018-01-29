//
//  UIViewController_NavAddtion.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/28.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
    public func setNavTitle(_ title: String,
                            titleColor: UIColor,
                            font: UIFont = UIFont.systemFont(ofSize: 17)) {
        let titleLabel = UILabel()
        titleLabel.updateWithConfigData(["text":title
            ,"textAlignment":NSTextAlignment.center.rawValue
            ,"textColor":titleColor
            ,"font":font])
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    public func setNavBarBgImage(_ image: UIImage) {
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    public func setNavBarBgColor(_ color : UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    public func setCleanNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    public func setNavLeftItem(_ title: String?
        , image: UIImage?
        , tintColor : UIColor? = nil
        , titleColor: UIColor?
        , font: UIFont?
        , action: (()->Void)?) {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(image, for: .normal)
        if tintColor != nil {
            button.imageView?.tintColor = tintColor!
        }
        button.titleLabel?.font = font ?? UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(title ?? "", for: UIControlState())
        button.setTitleColor(titleColor ?? UIColor.black, for: UIControlState())
        button.titleLabel?.sizeToFit()
        
        let titleSize = button.titleLabel?.size
        let imageSize = button.image(for: .normal)?.size
        if let size1 = titleSize, let size2 = imageSize {
            var size = size1
            if size.width < size2.width {
                size.width = size2.width
            }
            if size.height < size2.height {
                size.height = size2.height
            }
            button.size = size
        } else if let size1 = titleSize {
            button.size = size1
        } else if let size1 = imageSize {
            button.size = size1
        }
        
        let right = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = right
        _=button.rx.tap.subscribe(onNext: { (_) in
            action?()
        })
    }
    
    public func setNavRightItem(_ title: String?
        , image: UIImage?
        , tintColor : UIColor? = nil
        , titleColor: UIColor?
        , font: UIFont?
        , action: (()->Void)?) {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(image, for: .normal)
        if tintColor != nil {
            button.imageView?.tintColor = tintColor!
        }
        button.titleLabel?.font = font ?? UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle(title ?? "", for: UIControlState())
        button.setTitleColor(titleColor ?? UIColor.black, for: UIControlState())
        button.titleLabel?.sizeToFit()
        
        let titleSize = button.titleLabel?.size
        let imageSize = button.image(for: .normal)?.size
        if let size1 = titleSize, let size2 = imageSize {
            var size = size1
            if size.width < size2.width {
                size.width = size2.width
            }
            if size.height < size2.height {
                size.height = size2.height
            }
            button.size = size
        } else if let size1 = titleSize {
            button.size = size1
        } else if let size1 = imageSize {
            button.size = size1
        }
        
        let right = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = right
        _=button.rx.tap.subscribe(onNext: { (_) in
            action?()
        })
    }
    
    public func resetNavBackIcon(_ image: UIImage?) {
        if let image  = image {
            self.setNavLeftItem(nil, image: image, titleColor: nil, font: nil) { [unowned self] in
                _=self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
