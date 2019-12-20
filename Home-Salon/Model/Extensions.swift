//
//  Extensions.swift
//  Home-Salon
//
//  Created by Dr Mohan Roop on 8/22/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    @IBInspectable var placeholderColor: UIColor {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .lightText
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: newValue])
        }
    }
}


let appTextColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
let appSilverColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
let appWhiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let appNavyColor = UIColor(red: 19.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0)
