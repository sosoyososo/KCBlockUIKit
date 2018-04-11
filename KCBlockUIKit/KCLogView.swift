//
//  KCLogView.swift
//  WishClound
//
//  Created by karsa on 2018/1/29.
//  Copyright © 2018年 bugu. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

public class KCLogToogle {
    static let logsController = KCLogViewController.createHttpController()
    static let toggleView = UIView()
    
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
            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                var controller = rootController
                while (controller.presentedViewController != nil) {
                    controller = controller.presentedViewController!
                }
                if KCLogToogle.logsController.navigationController == nil {
                    controller.present(
                        UINavigationController.init(rootViewController: KCLogToogle.logsController),
                        animated: true,
                        completion: nil)
                } else {
                    KCLogToogle.logsController.navigationController?.popToRootViewController(animated: false)
                    KCLogToogle.logsController.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        })
        
        let longTap = UILongPressGestureRecognizer(target: nil, action: nil)
        toggleView.addGestureRecognizer(longTap)
        _=longTap.rx.event.subscribe(onNext: { (_) in
            KCLogManager.share.clearAll()
        })
        
        
        let gesture = UIPanGestureRecognizer(target: nil, action: nil)
        _=gesture.rx.event.subscribe(onNext: { (gesture) in
            var location = gesture.location(in: UIApplication.shared.keyWindow)
            location.x = min(location.x, KCScreenWidth-40)
            location.y = min(location.y, KCScreenSize.height-40)
            toggleView.snp.updateConstraints(  { (make) in
                make.left.equalTo(location.x)
                make.top.equalTo(location.y)
            })
            UIApplication.shared.keyWindow?.layoutIfNeeded()
        })
        toggleView.addGestureRecognizer(gesture)
    }
}

open class KCLogViewController : UIViewController {
    public var tags : [String]
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tags = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        tags = []
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(with tags : [String]) {
        self.init(nibName: nil, bundle: nil)
        self.tags = tags
    }
    
    private let table = KCBlockTableView()
    
    open override func loadView() {
        super.loadView()
        
        setNavBarBgColor(UIColor.white)
        setNavTitle("日志", titleColor: .black)
        
        
        setNavRightItem("filter", image: nil, titleColor: UIColor.blue, font: nil) { [unowned self] in
            self.showFilter()
        }
        
        setNavRightItem("cancel", image: nil, titleColor: UIColor.blue, font: nil) { [unowned self] in
            self.dismiss(animated: true, completion: {
            })
        }
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        table.cellConfig = { [unowned self] cell, indexPath in
            if let log = self.table.item(at: indexPath) as? KCLog {
                cell.textLabel?.text = log.mainLog()?.joined()
            }
        }
        table.indexPathSelected = { [unowned self] table, indexPath in
            if let log = self.table.item(at: indexPath) as? KCLog {
                let controller = KCLogDetailViewController(with: log)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        table.items = [KCLogManager.share.filterLog(with: tags)]
        table.reloadData()
        
        _=NotificationCenter
            .default
            .rx
            .notification(Notification.Name.init(KCLogContentChanged_Notification))
            .subscribe(onNext: { [weak self] (_) in
                if let tags = self?.tags {
                    self?.table.items = [KCLogManager.share.filterLog(with: tags)]
                }
                self?.table.reloadData()
            })
    }
    
    
    
    func showFilter() {
        let alert = UIAlertController.init(title: "filter", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for tag in KCLogManager.share.allLogTags {
            let action = UIAlertAction.init(title: tag, style: UIAlertActionStyle.default, handler: {  [unowned self] (_) in
                self.filter(with: tag)
            })
            alert.addAction(action)
        }
        let action = UIAlertAction.init(title: KCLogManager.allTagKey, style: UIAlertActionStyle.default, handler: { [unowned self] (_) in
            self.filter(with: KCLogManager.allTagKey)
        })
        alert.addAction(action)
        self.present(alert, animated: true) {
        }
    }
    
    func filter(with tag : String) {
        tags = [tag]
        table.items = [KCLogManager.share.filterLog(with: tags)]
        table.reloadData()
    }
}

extension KCLogViewController {
    public static func createHttpController() -> KCLogViewController {
        return KCLogViewController(with: [KCLogManager.httpTagKey])
    }
}

class KCLogDetailViewController : UIViewController {
    public var log : KCLog? = nil
    
    private let textView = UITextView()
    private var seg = UISegmentedControl()
    private var currentKey : String? = nil {
        didSet {
            self.textView.text = ""
            if let key = self.currentKey {
                if let strList = self.log?.allLogContent()[key] {
                    let text = strList.flatMap({ (item) -> String? in
                        return item.content
                    }).joined(separator: "\n")
                    self.textView.text = text
                }
            }
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(with log : KCLog) {
        self.init(nibName: nil, bundle: nil)
        self.log = log
    }
    
    override func loadView() {
        super.loadView()
        
        setNavBarBgColor(UIColor.white)
        setNavTitle(log?.mainLog()?.joined() ?? "详情", titleColor: .black)
        view.backgroundColor = .white
        view.addSubview(seg)
        seg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        _=seg.rx.selectedSegmentIndex.subscribe(onNext: { [unowned self] (index) in
            if index >= 0, let keys = self.log?.allLogContent().keys.flatMap({ (key) -> String? in
                return key
            }), keys.count > index {
                self.currentKey = keys[index]
            } else {
                self.currentKey = nil
            }
        })
        
        textView.isEditable = false
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(50)
        }
        
        updateUI()
        
        _=NotificationCenter
            .default
            .rx
            .notification(Notification.Name.init(KCLogContentChanged_Notification))
            .subscribe(onNext: { [weak self] (_) in
                self?.updateUI()
            })

    }
    
    public func updateUI() {
        self.seg.removeAllSegments()
        if let keys = self.log?.allLogContent().keys.flatMap({ (key) -> String? in
            return key
        }), keys.count > 0 {
            for i in 0..<keys.count {
                self.seg.insertSegment(withTitle: keys[i], at: i, animated: true)
            }
            seg.selectedSegmentIndex = 0
            currentKey = keys.first
        } else {
            currentKey = nil
        }
    }
}
