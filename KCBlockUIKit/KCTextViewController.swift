//
//  KCTextViewController.swift
//  KCBlockUIKit
//
//  Created by karsa on 2018/1/19.
//  Copyright © 2018年 karsa. All rights reserved.
//

import Foundation
import SnapKit

public class KCTextViewController : KCBlockViewController {
    public let textView = UITextView()
        
    override public  func loadView() {
        super.loadView()
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
