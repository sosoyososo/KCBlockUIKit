//
//  KCLoading.swift
//  WishClound
//
//  Created by karsa on 2017/9/1.
//

import UIKit

open class KCLoading: UIView {
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
        self.backgroundColor = UIColor.clear
        let view = self.addSubViewWithConfigData([KCViewClassKey:"UIView"
            , "backgroundColor":UIColor.init(white: 0, alpha: 0.75)
            , "layer.cornerRadius":4
            , "layer.masksToBounds":true])
        view?.snp.makeConstraints(  { (make) in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.center.equalToSuperview()
        })
        
        let activityIndicator = view?.addSubViewWithConfigData([KCViewClassKey:"UIActivityIndicatorView"]) as? UIActivityIndicatorView
        activityIndicator?.snp.makeConstraints(  { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        activityIndicator?.startAnimating()
    }
    
    public  func hide() {
        self.removeFromSuperview()
    }
}


extension UIView {
    public  func showKCLoading() -> KCLoading {
        let loading = KCLoading()
        addSubview(loading)
        loading.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return loading
    }
}

extension UIViewController {
    public  func showKCLoading() -> KCLoading {
        return self.view.showKCLoading()
    }
}
