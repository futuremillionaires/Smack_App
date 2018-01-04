//
//  AddChannelVC.swift
//  Smack
//
//  Created by Raju Dhumne on 04/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var chanDesc: UITextField!
    @IBOutlet weak var bgVIew: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

    }
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
    }
    
    
    func setUpView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector (AddChannelVC.closeTap(_:)))
        bgVIew.addGestureRecognizer(closeTouch)
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes:[NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
        chanDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
        
    }
    @objc func closeTap(_ recognizer:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
