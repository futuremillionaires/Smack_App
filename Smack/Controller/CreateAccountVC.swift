//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Raju Dhumne on 29/12/17.
//  Copyright © 2017 Raju Dhumne. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
//Outlets

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    @IBAction func createAccntPressed(_ sender: Any) {
        guard let email = emailTxt.text,emailTxt.text != "" else {return}
        guard let pass = passTxt.text,passTxt.text != "" else {return}
        AuthServices.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthServices.instance.userLogin(email: email, password: pass, completion: { (success) in
                    if success {
                        print("logged in usr!",
                              AuthServices.instance.authToken)
                    }
                })
                
            }
        }
        
    }
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
