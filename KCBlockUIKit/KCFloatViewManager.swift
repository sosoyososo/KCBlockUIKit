//
//  KCFloatViewManager.swift
//  KCBlockUIKit
//
//  Created by karsa on 2018/7/3.
//  Copyright © 2018年 karsa. All rights reserved.
//

import Foundation
import SnapKit

/*
 App 中有某些情况下需要在 Key Window 上直接显示一些内容，
 但这种情况多了之后，各自为政会导致整个App的弹框显得比较乱，
 我们增加这个管理器，用来管理加入到Window的View，
 加入到管理器的多个view，不会一起显示，而是会组成一个队列，一个接一个的显示
 前一个消失后，延迟0.25秒显示下一个
 */
public protocol KCFloatViewManagerDelegate {
    func hide()
}

public class KCFloatViewManager {
    private static let shareInstance : KCFloatViewManager = KCFloatViewManager()
    private var viewsToShow : [KCFloatViewItem] = []
    
    public let maskView = UIView()
    
    public class func addView(with viewItem : KCFloatViewItem) {        
        shareInstance.viewsToShow.append(viewItem)
        viewItem.didHideAction = {
            shareInstance.hasItemShown = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.microseconds(250),
                                          execute: {
                shareInstance.showItemIfPossible()
            })
        }
        shareInstance.showItemIfPossible()
    }
    
    internal class func cancelItem(viewItem : KCFloatViewItem) {
        if let index = shareInstance.viewsToShow.index(where: { (item) -> Bool in
            return item.contentView == viewItem.contentView
        }) {
            shareInstance.viewsToShow.remove(at: index)
        }
    }
    
    init() {
        maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.35)
    }
    private var hasItemShown : Bool = false
    private func showItemIfPossible() {
        if hasItemShown == false {
            if  viewsToShow.count > 0 {
                hasItemShown = true
                let item = viewsToShow.removeFirst()
                UIApplication.shared.keyWindow?.addSubview(maskView)
                maskView.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                maskView.addSubview(item.contentView)
                item.contentView.snp.makeConstraints(item.autoLayoutSetup)
                
                item.contentView.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    item.contentView.alpha = 1
                }) { (_) in
                }
            } else {
                maskView.removeFromSuperview()
            }
        }
    }
    
    
    public class KCFloatViewItem : KCFloatViewManagerDelegate {
        private var view : UIView
        public var contentView : UIView {
            get {
                return view
            }
        }
        
        public var willHideAction : ()->() = {
        }
        public var didHideAction : ()->() = {
        }
        public var autoLayoutSetup : (ConstraintMaker) -> () = { _ in
        }
        
        public init(with view : UIView) {
            self.view = view
        }
        
        public func hide() {
            willHideAction()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.didHideAction()
            }
        }
        
        public func cancel() {
            KCFloatViewManager.cancelItem(viewItem: self)
        }
    }
}
