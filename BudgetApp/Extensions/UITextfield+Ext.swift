//
//  UITextfield+Ext.swift
//  BudgetApp
//
//  Created by Nurşah ARİ on 12.10.2022.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

