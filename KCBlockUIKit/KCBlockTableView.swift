//
//  KCBlockTableView.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/26.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

open class KCBlockTableView : UITableView, UITableViewDataSource, UITableViewDelegate  {
    public var items : [[Any]]? {
        didSet {
            if nil == self.dataSource {
                self.dataSource = self
            }
            if nil == self.delegate {
                self.delegate = self
            }
        }
    }
    public var cellHeight : ((IndexPath) -> CGFloat) = { _ in
        return 44
    }
    public var cellGeneration : (UITableView, IndexPath) -> UITableViewCell = { (table, indexPath) in
        if let cell = table.dequeueReusableCell(withIdentifier: "") {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "")
    }
    public var cellConfig : ((UITableViewCell, IndexPath) -> Void) = {(_, _) in }
    public var indexPathSelected : ((UITableView, IndexPath) -> Void) = {(tableView, _) in
    }
    public var indexPathDeselected : ((UITableView, IndexPath) -> Void) = {(tableView, _) in
    }
    public var sectionHeaderHight : ((UITableView, Int) -> CGFloat) = { _, _ in
        return CGFloat(0)
    }
    public var sectionHeaderView :  ((UITableView, Int) -> UIView?) = { _, _ in
        return nil
    }
    public var sectionFooterHight : ((UITableView, Int) -> CGFloat) = { _, _ in
        return CGFloat(0)
    }
    public var sectionFooterView :  ((UITableView, Int) -> UIView?) = { _, _ in
        return nil
    }
    public var willDisplayCell : ((UITableViewCell, IndexPath)->()) = {_, _ in
    }
    public var didDisplayCell : ((UITableViewCell, IndexPath)->()) = {_, _ in
    }
    public var didScroll : ((CGPoint)->()) = { _ in
    }
    public var canEditIndexPath : (IndexPath)->Bool = { _ in
        return false
    }
    public var editStyleForIndexPath : (IndexPath)->UITableViewCellEditingStyle { _ in
        return UITableViewCellEditingStyle.none
    }
    public var editActionForIndexPath : (UITableView,IndexPath,UITableViewCellEditingStyle)->() = { _, _, _ in
    }
    public var willBeginEdit : (UITableView,IndexPath)->() = { _, _ in
    }
    public var editDidEnd : (UITableView,IndexPath)->() = { _, _ in
    }
    public var rowAction : (UITableView,IndexPath)->[UITableViewRowAction]? = {_, _ in
        return nil
    }
    public var rowDeleteConfirmBtnTitle : (UITableView, IndexPath)->String? = { _, _ in
        return nil
    }
    
    // MARK: Data Source & Delegate
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let count = items?.count {
            return count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items?[section].count {
            return count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView(tableView, section)
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHight(tableView, section)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionFooterHight(tableView, section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionFooterView(tableView, section)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cellGeneration(tableView, indexPath)
        self.cellConfig(cell, indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathSelected(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        indexPathDeselected(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell(cell, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didDisplayCell(cell, indexPath)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(contentOffset)
    }
    
    // MARK: Edit Table
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditIndexPath(indexPath)
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return editStyleForIndexPath(indexPath)
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        editActionForIndexPath(tableView, indexPath, editingStyle)
    }
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEdit(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editDidEnd(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return rowAction(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return rowDeleteConfirmBtnTitle(tableView, indexPath) ?? "删除"
    }
}
