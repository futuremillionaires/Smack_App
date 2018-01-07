//
//  ChatVC.swift
//  Smack
//
//  Created by Raju Dhumne on 28/12/17.
//  Copyright © 2017 Raju Dhumne. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var messageBoxTxt: UITextField!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthServices.instance.isLoggedIn {
            AuthServices.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
       
    }
    
    
    @objc func userDataDidChanged(_ notif: Notification){
        
        if AuthServices.instance.isLoggedIn {
            onLoginGetMessage()
        }else {
            channelNameLbl.text = "Please Login"
        }
    }
    
    @IBAction func messageSendBtnPressed(_ sender: Any) {
        if AuthServices.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else{return}
            guard let message  = messageBoxTxt.text else {return}
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageBoxTxt.text = ""
                    self.messageBoxTxt.resignFirstResponder()
                }
            })
        }
        
        
    }
    @objc func channelSelected(_ notif: Notification){
        updateWithChannel()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessage()
    }
    
    func onLoginGetMessage() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.channelNameLbl.text = "NO CHANNEL"
                }
            }
        }
    }
    
    
    func getMessage() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (response) in
            print("Message")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
