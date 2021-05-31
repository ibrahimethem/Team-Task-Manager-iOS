//
//  MyTextField.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 30.05.2021.
//

import UIKit

@IBDesignable
class MyTextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
}

