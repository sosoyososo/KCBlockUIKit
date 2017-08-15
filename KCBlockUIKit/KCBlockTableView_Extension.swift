//
//  KCExtensionBlockTableView.swift
//  AimToUniversity
//
//  Created by karsa on 17/2/10.
//  Copyright © 2017年 karsa. All rights reserved.
//

import Foundation
import UIKit

open class KCBlockTableCell : UITableViewCell {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    open var select : Bool = true
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
        self.select = false
    }
    
    open func initSetup() {
    }
    open func configCell(_ data : Any?) {
    }
    open func upDateCell(_ select:Bool) {
        self.select = select
    }
}

open class KCBlockTableItem {
    open var data : Any?
    open var cellClass : KCBlockTableCell.Type?
    open var cellHeight : CGFloat  {
        return 44.0
    }
    public init(_ data: Any?, cellClass : KCBlockTableCell.Type?) {
        self.data = data
        self.cellClass = cellClass
    }
}

extension KCBlockSimpleTableView {
    public func item(at indexPath: IndexPath) -> Any? {
        if let items = items {
            if indexPath.section < items.count {
                let sectionItems = items[indexPath.section]
                if indexPath.row < sectionItems.count {
                    return sectionItems[indexPath.row]
                }
            }
        }
        return nil
    }
    
    public func isSectionLastRow(_ indexPath : IndexPath) -> Bool {
        var isLast = false
        if let count = self.items?.count {
            if indexPath.section < count {
                if indexPath.row == self.items![indexPath.section].count - 1 {
                    isLast = true
                }
            }
        }
        return isLast
    }
}


extension UITableViewCell {
    public func getCurrentTableView() -> UITableView? {
        var view = self.superview
        while view != nil {
            if let table = view as? UITableView {
                return table
            }
            view = view?.superview
        }
        return nil
    }
}
