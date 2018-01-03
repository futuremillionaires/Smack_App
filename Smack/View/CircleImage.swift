//
//  CircleImage.swift
//  Smack
//
//  Created by Raju Dhumne on 03/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
     setUpView()
    }
    func setUpView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
}
