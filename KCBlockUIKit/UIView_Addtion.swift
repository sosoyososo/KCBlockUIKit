//
//  UIView_Addtion.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/26.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation
import SnapKit
import RxCocoa

public let KCViewClassKey = "KCViewClass"
let KCView_Action_Key = "KCView_Action_Key"

extension UIView {
    
    public var left : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    public var top : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    public var right : CGFloat {
        get {
            return frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    public var bottom : CGFloat {
        get {
            return frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    public var height : CGFloat {
        get {
            return self.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    public var width : CGFloat {
        get {
            return self.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    public var centerX : CGFloat {
        get {
            return (self.frame.origin.x + self.frame.size.width)/2
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width/2
            self.frame = frame
        }
    }
    public var centerY : CGFloat {
        get {
            return (self.frame.origin.y + self.frame.size.height)/2
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height/2
            self.frame = frame
        }
    }
    
    public var size : CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    public var origin : CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
    // MARK: Event
    public func setViewAction(_ viewAction : ((UIView?)->Void)?) {
        if let tap = objc_getAssociatedObject(self, KCView_Action_Key) as? UITapGestureRecognizer {
            self.removeGestureRecognizer(tap)
        }
        
        if nil != viewAction {
            let tap = UITapGestureRecognizer(target: nil, action: nil)
            self.addGestureRecognizer(tap)
            objc_setAssociatedObject(self, KCView_Action_Key, tap, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
            weak var weakSelf = self
            _=tap.rx.event.takeUntil(self.rx.deallocating).subscribe(onNext: { (_) in
                viewAction!(weakSelf)
            })
        }
    }
    
    // MARK: construct view structure with config data
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("+++++++++++++++ KCUIKitAdtion UIView_Addtion +++++++++++++++")
        print("\(key) == \(value ?? "")")
    }
    
    public func updateWithConfigData(_ data : [String:Any]?) {
        weak var  weakSelf = self
        data?.forEach({ (key, value) in
            if key != KCViewClassKey {
                weakSelf?.setValue(value, forKeyPath: key)
            }
        })
    }
    
    public func addSubViewWithConfigData(_ data : [String:Any]?) -> UIView? {
        if let className = data?[KCViewClassKey] as? String, className.characters.count > 0 {
            if let cls = NSClassFromString(className) as? UIView.Type {
                let view = cls.init(frame: CGRect.zero)
                self.addSubview(view)
                view.updateWithConfigData(data)
                return view
            }
        }
        return nil
    }
    
    public func addSubViewListWithConfigData(_ dataList: [[String:Any]]?) -> [UIView?] {
        weak var  weakSelf = self
        var views = [UIView?]()
        dataList?.forEach({ (data) in
            views.append(weakSelf?.addSubViewWithConfigData(data))
        })
        return views
    }
    
    // MARK: snapkit update 
    public var snp_maker : ((_ make: SnapKit.ConstraintMaker)->Void)? {
        get {
            return nil
        }
        set {
            self.snp.remakeConstraints { (make) in
                newValue?(make)
            }
        }
    }
    
    public var snp_update : ((_ make: SnapKit.ConstraintMaker)->Void)? {
        get {
            return nil
        }
        set {
            self.snp.remakeConstraints { (make) in
                newValue?(make)
            }
        }
    }
    
    public var snp_remake : ((_ make: SnapKit.ConstraintMaker)->Void)? {
        get {
            return nil
        }
        set {
            self.snp.remakeConstraints { (make) in
                newValue?(make)
            }
        }
    }
    
    public var snp_float : [String:CGFloat] {
        get {
            return [String:CGFloat]()
        }
        set {
            if nil != self.superview {
                self.snp.remakeConstraints({ (make) in
                    let map = ["width":make.width
                        , "height":make.height
                        , "left":make.left
                        , "right":make.right
                        , "top":make.top
                        , "bottom":make.bottom
                        , "centerX":make.centerX
                        , "centerY":make.centerY
                        , "baseline":make.baseline
                        , "firstBaseline":make.firstBaseline]
                        
                    newValue.forEach({ (key, value) in
                        if let cons = map[key] {
                            cons.equalTo(value)
                        }
                    })
                })
            }
        }
    }
    
    public var snp_size : CGSize {
        get {
            return CGSize.zero
        }
        set {
            self.snp.updateConstraints { (make) in
                make.size.equalTo(newValue)
            }
        }
    }
    
    public var snp_center : CGPoint {
        get {
            return CGPoint.zero
        }
        set {
            self.snp.updateConstraints { (make) in
                make.center.equalTo(newValue)
            }
        }
    }
    
    public var snp_edges : UIEdgeInsets {
        get {
            return UIEdgeInsets.zero
        }
        set {
            self.snp.remakeConstraints { (make) in
                make.edges.equalTo(newValue)
            }
        }
    }
    
    // MARK: AddSep
    public enum KCUIViewSeparatorType {
        case top
        case bottom
        case left
        case right
        case centerV //中间竖线
        case centerH //中间横线
    }
    
    public func addSeparator(_ lineColor: UIColor, margin : CGFloat = 0, separatorType: KCUIViewSeparatorType) -> UIView? {
        let view = self.addSubViewWithConfigData([KCViewClassKey:"UIView" 
            ,"backgroundColor":lineColor])
        view?.snp.makeConstraints({ (make) in
            switch separatorType {
            case .top:
                make.top.equalTo(0)
                make.left.equalTo(margin)
                make.right.equalTo(-margin)
                make.height.equalTo(KCPointPerPixel)
            case .bottom:
                make.bottom.equalTo(0)
                make.left.equalTo(margin)
                make.right.equalTo(-margin)
                make.height.equalTo(KCPointPerPixel)
            case .centerH:
                make.centerY.equalToSuperview()
                make.left.equalTo(margin)
                make.right.equalTo(-margin)
                make.height.equalTo(KCPointPerPixel)
            case .left:
                make.left.equalTo(0)
                make.top.equalTo(margin)
                make.bottom.equalTo(-margin)
                make.width.equalTo(KCPointPerPixel)
            case .right:
                make.right.equalTo(0)
                make.top.equalTo(margin)
                make.bottom.equalTo(-margin)
                make.width.equalTo(KCPointPerPixel)
            case .centerV:
                make.centerX.equalToSuperview()
                make.top.equalTo(margin)
                make.bottom.equalTo(-margin)
                make.width.equalTo(KCPointPerPixel)
            }
        })
        return view
    }
    
    // shape
    public func setCorner(_ corners : UIRectCorner, radius : CGFloat, viewBounds: CGRect) {
        let path = UIBezierPath(roundedRect: viewBounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
}

extension UIView {
    public func getController() -> UIViewController? {
        var responsder : UIResponder = self
        while true {
            if let next  = responsder.next {
                if let ctr = next as? UIViewController {
                    return ctr
                }
                responsder = next
            } else {
                return nil
            }
        }
    }
}
