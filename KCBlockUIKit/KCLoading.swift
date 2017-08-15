//
//  KCLoading.swift
//  KCBlockUIKit
//
//  Created by karsa on 2017/8/15.
//  Copyright © 2017年 karsa. All rights reserved.
//

import UIKit

open class KCLoading {
    private let loading = KCLoadingView()
    private let masks = UIView()
    public class func showLoading(in view : UIView) -> KCLoading {
        let load = KCLoading()
        load.masks.backgroundColor = UIColor.clear
        
        view.addSubview(load.masks)
        load.masks.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        load.masks.addSubview(load.loading)
        load.loading.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        DispatchQueue.main.async { [weak load] in
            load?.loading.indicator.startAnimating()
        }
        return load
    }
    
    public func hide() {
        masks.removeFromSuperview()
    }
    
}

class KCLoadingView: UIView {
    let indicator = UIActivityIndicatorView()
    init() {
        super.init(frame: CGRect.zero)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    func setUp() {
        backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.65)
        layer.masksToBounds = true
        layer.cornerRadius = 4
        addSubview(indicator)
        indicator.sizeToFit()
        let size = indicator.size
        indicator.snp.makeConstraints { (make) in
            make.size.equalTo(size)
            make.center.equalToSuperview()
        }
    }
}
