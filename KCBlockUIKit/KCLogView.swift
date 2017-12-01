//
//  KCLogView.swift
//  WishClound
//
//  Created by karsa on 2017/9/4.
//

import Foundation

open class KCLogView : UIView {
    fileprivate let textView = UITextView()
    static var toggleView = UIView()
    
    public  static let instance = KCLogView()
    public  static var addLogAction : (String)->() = { _ in
    }
    
    public class func addLogToggle() {
        if toggleView.superview != nil {
            return
        }
        
        toggleView.updateWithConfigData(["backgroundColor":KCRGBAColor(0,0,0,0.65)
            , "layer.masksToBounds":true
            , "layer.cornerRadius":4])
        UIApplication.shared.keyWindow?.addSubview(toggleView)
        toggleView.snp.makeConstraints(  { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalTo(0)
            make.top.equalTo(100)
        })
        
        toggleView.addSubViewWithConfigData([KCViewClassKey:"UIView"
            , "backgroundColor":UIColor.lightGray, "layer.masksToBounds":true
            , "layer.cornerRadius":15])?.snp.makeConstraints(  { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 30, height: 30))
            })
        
        toggleView.setViewAction({ (_) in
            if KCLogView.hasShow() {
                KCLogView.hide()
            } else {
                KCLogView.show()
            }
        })
        
        let longTap = UILongPressGestureRecognizer(target: nil, action: nil)
        toggleView.addGestureRecognizer(longTap)
        _=longTap.rx.event.subscribe(onNext: { (_) in
            KCLogView.instance.textView.text = ""
            KCLogView.addLog("//////////////// clear content /////////////////////////")
        })
        
        
        let gesture = UIPanGestureRecognizer(target: nil, action: nil)
        _=gesture.rx.event.subscribe(onNext: { (gesture) in
            var location = gesture.location(in: UIApplication.shared.keyWindow)
            location.x = min(location.x, KCScreenWidth-40)
            location.y = min(location.y, KCScreenSize.height-40)
            KCLogView.toggleView.snp.updateConstraints(  { (make) in
                make.left.equalTo(location.x)
                make.top.equalTo(location.y)
            })
            UIApplication.shared.keyWindow?.layoutIfNeeded()
        })
        toggleView.addGestureRecognizer(gesture)
    }
    
    public class func show() {
        if instance.superview == nil {
            UIApplication.shared.keyWindow?.insertSubview(instance, belowSubview: KCLogView.toggleView)
            instance.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        instance.isHidden = false
    }
    
    public class func hide() {
        instance.isHidden = true
    }
    
    public class func hasShow() -> Bool{
        return instance.superview != nil && instance.isHidden == false
    }
    
    public class func addLog(_ log : String) {
        addLogAction(log)
        var str = ""
        
        if let tmp = instance.textView.text {
            str += tmp
        }
        
        str += "\n"
        str += log
        
        let maxLength = 2000
        var lines = str.components(separatedBy: "\n")
        if lines.count > maxLength {
            lines = Array<String>.init(lines[lines.count-maxLength..<lines.count])
            str = lines.joined(separator: "\n")
        }
        
        instance.textView.text = str
        instance.textView.scrollRangeToVisible(NSMakeRange(str.characters.count-2, 1))
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        self.textView.backgroundColor = KCRGBAColor(0,0,0,0.75)
        self.textView.textColor = UIColor.red
        self.textView.isEditable = false
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
