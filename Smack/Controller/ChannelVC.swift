//
//  ChannelVC.swift
//  Smack
//
//  Created by Raju Dhumne on 28/12/17.
//  Copyright © 2017 Raju Dhumne. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 85
    }

   

}
