//
//  RoundedCorner.swift
//  Smack
//
//  Created by Raju Dhumne on 01/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedCorner: UIButton {
    @IBInspectable var cornerRadius:CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setUpView()
    }
    override func prepareForInterfaceBuilder() {
       super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    func setUpView() {
        self.layer.cornerRadius = cornerRadius
    }
}
