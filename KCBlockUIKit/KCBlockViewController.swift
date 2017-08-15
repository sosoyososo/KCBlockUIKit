//
//  KCBlockViewController.swift
//  KCUIKitAddtion
//
//  Created by karsa on 2017/5/4.
//  Copyright © 2017年 karsa. All rights reserved.
//

import UIKit

public class KCBlockViewController: UIViewController {
    public var loadViewAction : (KCBlockViewController)->() = { _ in
    }
    
    public var viewWillAppearAction : (KCBlockViewController)->() = { _ in
    }
    
    public var viewWillDisappearAction : (KCBlockViewController)->() = { _ in
    }
    
    
    
    override public  func loadView() {
        super.loadView()
        loadViewAction(self)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearAction(self)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearAction(self)
    }
}
