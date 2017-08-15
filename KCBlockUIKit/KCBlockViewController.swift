//
//  KCBlockViewController.swift
//  KCUIKitAddtion
//
//  Created by karsa on 2017/5/4.
//  Copyright © 2017年 karsa. All rights reserved.
//

import UIKit

open class KCBlockViewController: UIViewController {
    public var loadViewAction : (KCBlockViewController)->() = { _ in
    }
    
    public var viewWillAppearAction : (KCBlockViewController)->() = { _ in
    }
    
    public var viewWillDisappearAction : (KCBlockViewController)->() = { _ in
    }
    
    
    
    public override func loadView() {
        super.loadView()
        loadViewAction(self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearAction(self)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearAction(self)
    }
}
