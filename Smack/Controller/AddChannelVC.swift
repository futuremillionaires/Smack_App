//
//  AddChannelVC.swift
//  Smack
//
//  Created by Raju Dhumne on 07/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
//Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelDesc: UITextField!
    @IBOutlet weak var channelName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = channelName.text,channelName.text != "" else {return}
        guard let desc = channelDesc.text else {return}
        SocketService.instance.addChannel(name: name, description: desc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTouch(_:)))
        bgView.addGestureRecognizer(tap)
        channelName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        channelDesc.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        
    }
    @objc func closeTouch(_ recognizer:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
