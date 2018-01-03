//
//  ChannelVC.swift
//  Smack
//
//  Created by Raju Dhumne on 28/12/17.
//  Copyright © 2017 Raju Dhumne. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
   
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 85
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChanged(_:)), name:NOTIF_USER_DATA_DID_CHANGE , object: nil)
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthServices.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else {
           performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    @objc func userDataDidChanged(_ notif:Notification){
        if AuthServices.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named:UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(componenets: UserDataService.instance.avatarColor)
        }else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named:"menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
    }
}







