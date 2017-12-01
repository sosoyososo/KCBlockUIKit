//
//  KCControllerOrientationManager.swift
//  WishClound
//
//  Created by karsa on 2017/11/15.

//

import Foundation
import UIKit

fileprivate class KCControllerOrientationManager {
    private var registerd : [String:UIInterfaceOrientationMask] = [:]
    
    static let share : KCControllerOrientationManager = {
        UIViewController.userOrientationManager()
        return KCControllerOrientationManager()
    }()
    
    static func registerOrientation(on controllerCls : AnyClass, with mask : UIInterfaceOrientationMask) {
        share.registerd[NSStringFromClass(controllerCls)] = mask
    }
    
    static func registerdOrientationMask(on controllerCls : AnyClass) -> UIInterfaceOrientationMask? {
        return share.registerd[NSStringFromClass(controllerCls)]
    }
}

extension UIViewController {
    public class func registerOrientation(with mask : UIInterfaceOrientationMask) {
        KCControllerOrientationManager.registerOrientation(on: self, with: mask)
    }
    
    var shouldAutorotate1 : Bool {
        if let _ = KCControllerOrientationManager.registerdOrientationMask(on : self.firstShownController().classForCoder) {
            return true
        }
        return false
    }
    
    var supportedInterfaceOrientations1 : UIInterfaceOrientationMask {
        if let o = KCControllerOrientationManager.registerdOrientationMask(on : self.firstShownController().classForCoder) {
            return o
        }
        return UIInterfaceOrientationMask.portrait
    }
    
    func isContainerController() -> Bool {
        return childViewControllers.count > 0
    }
    
    func firstShownController() -> UIViewController {
        if isContainerController() == false {
            return self
        } else {
            if let nav = self as? UINavigationController {
                return nav.topViewController?.firstShownController() ?? nav
            } else if let tab = self as? UITabBarController {
                return tab.selectedViewController?.firstShownController() ?? tab
            } else {
                return childViewControllers.last ?? self
            }
        }
    }
    
    class func userOrientationManager() {
        let selector1 = #selector(getter: shouldAutorotate)
        if let method = class_getInstanceMethod(UIViewController.classForCoder(), selector1) {
            let imp = class_getMethodImplementation(UIViewController.classForCoder(),
                                                    #selector(getter: shouldAutorotate1))
            method_setImplementation(method, imp)
        }
        
        let selector2 = #selector(getter: supportedInterfaceOrientations)
        if let method = class_getInstanceMethod(UIViewController.classForCoder(), selector2) {
            let imp = class_getMethodImplementation(UIViewController.classForCoder(),
                                                    #selector(getter: supportedInterfaceOrientations1))
            method_setImplementation(method, imp)
        }
    }
}
