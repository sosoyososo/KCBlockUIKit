//
//  KCTips.swift
//  WishClound
//
//  Created by karsa on 2017/9/1.
//  Copyright © 2017年 bugu. All rights reserved.
//

import UIKit
import RxSwift

extension ObservableType {
    public func delay(time: TimeInterval, scheduler: SchedulerType = MainScheduler.instance) -> Observable<E> {
        return self.flatMap { element in
            Observable<Int>.timer(time, scheduler: scheduler)
                .map { _ in
                    return element
            }
        }
    }
}

open class KCTips: UIView {
    private let label = UILabel()
    public var tips : String = "" {
        didSet {
            label.text = tips
            let size = label.sizeThatFits(CGSize(width: 240, height: 400))
            label.superview?.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize(width: size.width+10, height: size.height+10))
            })
            layoutIfNeeded()
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        backgroundColor = UIColor.clear
        
        let view = UIView()
        addSubview(view)
        view.updateWithConfigData(["backgroundColor":UIColor.init(white: 0, alpha: 0.75)
            , "layer.cornerRadius":4
            , "layer.masksToBounds":true])
        view.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 40))            
            make.center.equalToSuperview()
        }

        label.updateWithConfigData(["textColor":UIColor.white,
                                    "textAlignment":NSTextAlignment.center.rawValue,
                                    "font":UIFont.systemFont(ofSize: 12)])
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview().inset(5)
        }
        
    }
}

extension UIView {
    public func showKCTips(with tips : String,
                    autoHide : ((Float, (()->())?))? = nil) -> KCTips {
        let loading = KCTips()
        addSubview(loading)
        loading.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loading.tips = tips
        
        if let autoHideInfo = autoHide {
            let (duration, didHideAction) = autoHideInfo
            _=Observable<Void>.create({ (observer) -> Disposable in
                observer.onNext(())
                return Disposables.create()
            }).delay(time: TimeInterval.init(duration)).subscribe(onNext: { [weak loading] () in
                loading?.removeFromSuperview()
                didHideAction?()
            })
        }
    
        return loading
    }
}

extension UIViewController {    
    public func showKCTips(with tips : String,
                    autoHide : ((Float, (()->())?))? = nil) -> KCTips {
        return view.showKCTips(with: tips, autoHide: autoHide)
    }
}
