//
//  LoginVC.swift
//  Smack
//
//  Created by Raju Dhumne on 29/12/17.
//  Copyright © 2017 Raju Dhumne. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        guard let email = userNameTxt.text,userNameTxt.text != "" else {return}
        guard let pass = passwordTxt.text,passwordTxt.text != "" else {return}
        
        AuthServices.instance.userLogin(email: email, password: pass) { (success) in
            if success {
                AuthServices.instance.findUserByEmail(completion: { (success) in
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
        
    }
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createAccntBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    func setupView() {
        spinner.isHidden = true
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "UserName", attributes: [NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
    }
    
}


