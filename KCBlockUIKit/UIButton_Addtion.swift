//
//  UIButton.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/26.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UIButton {
    public var title : String? {
        get {
            return self.title(for: UIControl.State.normal)
        }
        set {
            self.setTitle(newValue, for: UIControl.State.normal)
        }
    }
    public var titleColor : UIColor? {
        get {
            return self.titleColor(for: UIControl.State.normal)
        }
        set {
            self.setTitleColor(newValue, for: UIControl.State.normal)
        }
    }
    public var titleFont : UIFont? {
        get {
            return self.titleLabel?.font
        }
        set {
            self.titleLabel?.font = newValue
        }
    }
    public var titleShadowColor: UIColor? {
        get {
            return self.titleShadowColor(for: UIControl.State.normal)
        }
        set {
            self.setTitleShadowColor(newValue, for: UIControl.State.normal)
        }
    }
    public var image : UIImage? {
        get {
            return self.image(for: UIControl.State.normal)
        }
        set {
            self.setImage(newValue, for: UIControl.State.normal)
        }
    }
    public var backgroundImage : UIImage? {
        get {
            return self.backgroundImage(for: UIControl.State.normal)
        }
        set {
            self.setBackgroundImage(newValue, for: UIControl.State.normal)
        }
    }
    public var attributedTitle : NSAttributedString? {
        get {
            return self.attributedTitle(for: UIControl.State.normal)
        }
        set {
            self.setAttributedTitle(newValue, for: UIControl.State.normal)
        }
    }
    
    public enum KCUIButtonImagePosition {
        case left
        case right
        case bottom
        case top
        
        public static var defaultPosition : KCUIButtonImagePosition {
            return KCUIButtonImagePosition.left
        }
    }
    public func setImagePosition(_ spacing : CGFloat = 6.0, position : KCUIButtonImagePosition, imageOffset : CGPoint? = nil) {
        let action = { [weak self] in
            let offsetX = imageOffset?.x ?? 0.0
            let offsetY = imageOffset?.y ?? 0.0
            
            if let imageSize = self?.imageView?.size
                ,let titleSize = self?.titleLabel?.size {
                var titleEdges : UIEdgeInsets = .zero
                var imgEdges : UIEdgeInsets = .zero
                switch position {
                case .left:
                    titleEdges = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
                    imgEdges = UIEdgeInsets(top: offsetY, left: offsetX, bottom: -offsetY, right: spacing-offsetX)
                case .right:
                    titleEdges = UIEdgeInsets(top: 0, left: -(imageSize.width)-spacing, bottom: 0, right: (imageSize.width))
                    imgEdges = UIEdgeInsets(top: offsetY, left: (titleSize.width)+offsetX, bottom: -offsetY, right: -(titleSize.width)-spacing-offsetX)
                case .bottom:
                    titleEdges = UIEdgeInsets(top: -(imageSize.height + spacing), left: -imageSize.width, bottom: 0, right: 0.0)
                    imgEdges = UIEdgeInsets(top: offsetY, left: offsetX, bottom: -offsetY-(titleSize.height + spacing), right: -titleSize.width-offsetX)
                case .top:
                    titleEdges = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
                    imgEdges = UIEdgeInsets(top: offsetY-(titleSize.height + spacing), left: offsetX, bottom: -offsetY, right: -offsetX-titleSize.width)
                }
                
                if self?.titleEdgeInsets != titleEdges {
                    self?.titleEdgeInsets = titleEdges
                }
                if self?.imageEdgeInsets != imgEdges {
                    self?.imageEdgeInsets = imgEdges
                }
            }
        }
        _=self.titleLabel?.rx.observe(CGRect.self, "frame").subscribe(onNext: { (_) in
            KCMainQueueAsnyAction {
                action()
            }
        })
        _=self.imageView?.rx.observe(CGRect.self, "frame").subscribe(onNext: { (_) in
            KCMainQueueAsnyAction {
                action()
            }
        })
    }
}
