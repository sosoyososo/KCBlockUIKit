//
//  KCStatusBarStyleManager.swift
//  WishClound
//
//  Created by karsa on 2017/11/7.
//

import Foundation

open class KCStatusBarStyleManager {
    private var typeMap : [String:Int] = [:]
    
    static let share : KCStatusBarStyleManager = {
        UIViewController.useStatusBarManager()
        return KCStatusBarStyleManager()
    }()
    
    fileprivate class func statusBarStyle(of cls : AnyClass) -> UIStatusBarStyle? {
        if let rawValue = share.typeMap[NSStringFromClass(cls)] {
            if let type = UIStatusBarStyle.init(rawValue: rawValue) {
                return type
            }
        }
        return nil
    }
    
    class func register(_ style : UIStatusBarStyle, on cls : AnyClass) -> Bool {
        let clsKey = NSStringFromClass(cls)
        share.typeMap[clsKey] = style.rawValue
        return true
    }
}

extension UIViewController {
    var registeredStatusBarStyle : UIStatusBarStyle {
        return KCStatusBarStyleManager.statusBarStyle(of: self.classForCoder) ?? .default
    }
    
    
    class func registerStatusBarStyle(_ style : UIStatusBarStyle) {
        _=KCStatusBarStyleManager.register(style, on: self)
    }
    
    func viewWillAppear1(_ animated: Bool) {
        viewWillAppear1(animated)
        if let nav = navigationController {
            if preferredStatusBarStyle == .default {
                nav.navigationBar.barStyle = .default
            } else {
                nav.navigationBar.barStyle = .black
            }
        }
    }
    
    class func useStatusBarManager() {        
        if let method = class_getInstanceMethod(UIViewController.self, #selector(viewWillAppear(_:)))
            ,let method1 = class_getInstanceMethod(UIViewController.self, #selector(viewWillAppear1(_:))) {
            method_exchangeImplementations(method, method1)
        }
        
        let selector = #selector(getter: preferredStatusBarStyle)
        if let method = class_getInstanceMethod(UIViewController.classForCoder(), selector) {
            let imp = class_getMethodImplementation(UIViewController.classForCoder(),
                                                    #selector(getter: registeredStatusBarStyle))
            method_setImplementation(method, imp)
        }
    }
}
