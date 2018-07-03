//
//  ViewController.swift
//  Demo
//
//  Created by karsa on 2018/7/3.
//  Copyright © 2018年 karsa. All rights reserved.
//

import UIKit
import KCBlockUIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .custom)
        view.addSubview(btn)
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        btn.setViewAction { [weak self] (_) in
            self?.testFloatViewManager()
        }
    }
    
    func testFloatViewManager() {
        for i in 0..<10 {
            let view = UIView()
            view.updateWithConfigData(["backgroundColor":UIColor.init(white: CGFloat(i)/10.0, alpha: 1)])
            let item = KCFloatViewManager.KCFloatViewItem.init(with: view)
            item.autoLayoutSetup = { maker in
                maker.size.equalTo(CGSize.init(width: 100, height: 100))
                maker.center.equalToSuperview()
            }
            view.setViewAction({ (_) in
                item.hide()
            })
            KCFloatViewManager.addView(with: item)
        }
    }
}

