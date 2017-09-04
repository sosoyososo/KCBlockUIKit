//
//  FuncMacro.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/31.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

public let KCRGBAColor =   { (r : CGFloat, g : CGFloat, b : CGFloat, a : CGFloat) -> UIColor in
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

public let KCRGBColor =   { (r : CGFloat, g : CGFloat, b : CGFloat) -> UIColor in
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

public let KCHEXColor = { (hexValue : Int) in
    return KCRGBColor(CGFloat((hexValue & 0xFF0000) >> 16), CGFloat((hexValue & 0x00FF00) >> 8), CGFloat((hexValue & 0x0000FF)))
}

public let KCCGPointCenter =  { (point1: CGPoint, point2: CGPoint) -> CGPoint in
    return CGPoint(x: (point1.x+point2.x)/2, y: (point1.y+point2.y)/2)
}

public let KCDeferMainQueueAction : (TimeInterval, @escaping ()->())->() = { sec, action in
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(sec * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        action()
    }
}

public let KCMainQueueAsnyAction : (((()->())?)->()) = { action in
    DispatchQueue.main.async(execute: {
        action?()
    })
}

public let KCPointPerPixel = (1.0/UIScreen.main.scale)
public let KCScreenSize = UIScreen.main.bounds.size
public let KCScreenWidth = UIScreen.main.bounds.size.width
public let KCScreenHeight = UIScreen.main.bounds.size.height

public func KCVersionString() -> String {
    if let info = Bundle.main.infoDictionary {
        let key = String("CFBundleShortVersionString")
        if let version = info[key!] as? String {
            return version
        }
    }
    return "1.0.0"
}

public func KCBuildVersionString() -> String {
    if let info = Bundle.main.infoDictionary {
        let key = String("CFBundleVersion")
        if let version = info[key!] as? String {
            return "\(version)"
        }
    }
    return "1"
}



