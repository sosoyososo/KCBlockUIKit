//
//  IBHook.swift
//  WishClound
//
//  Created by karsa on 2017/11/27.
//

import Foundation

typealias KCIBHookCallBack = (NSObject)->()
open class KCIBHookManager {
    private var globalHooks : [(KCIBHookCallBack,String)] = []
    private var classHooks : [(KCIBHookCallBack,String,AnyClass)] = []
    
    private static let manager = KCIBHookManager()
    
    public class func addClassHook(_ hook : @escaping KCIBHookCallBack, forClass : AnyClass, with key : String) {
        manager.classHooks.append((hook, key, forClass))
    }
    
    public class func addGlobalHook(_ hook : @escaping KCIBHookCallBack, with key : String) {
        manager.globalHooks.append((hook, key))
    }
    
    class func hook(nsobject obj : NSObject) {
        for hook in manager.globalHooks {
            hook.0(obj)
        }
        
        for hook in manager.classHooks {            
            if obj.isKind(of: hook.2) {
                hook.0(obj)
            }
        }
    }
}

extension NSObject {
    func _ibhook_awakeFromNib1() {
        _ibhook_awakeFromNib1()
        KCIBHookManager.hook(nsobject: self)
    }
    
    class func useIBHook() {
        let method2 = class_getInstanceMethod(NSObject.self, #selector(_ibhook_awakeFromNib1))
        let method = class_getInstanceMethod(NSObject.self, #selector(awakeFromNib))
        method_exchangeImplementations(method, method2)
    }
}
