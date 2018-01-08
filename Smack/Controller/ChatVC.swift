//
//  ChatVC.swift
//  Smack
//
//  Created by Raju Dhumne on 28/12/17.
//  Copyright © 2017 Raju Dhumne. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingUserLbl: UILabel!
    @IBOutlet weak var messageBoxTxt: UITextField!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    //Variable
    var isTyping = false
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        sendBtn.isHidden = true
        super.viewDidLoad()
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthServices.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        
        
        
        
        
//        SocketService.instance.getMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//                if MessageService.instance.messages.count > 0 {
//                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
//            }
//        }
        SocketService.instance.getTypingUser { (typingUser) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var name = ""
            var numberOfUser = 0
            for (typingUser,channel) in typingUser {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if name == "" {
                        name = typingUser
                    }else {
                        name = "\(name),\(typingUser)"
                    }
                    numberOfUser += 1
                }
            }
            if numberOfUser > 0 && AuthServices.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfUser > 1 {
                    verb = "are"
                }
                self.typingUserLbl.text = "\(name) \(verb) typing a message..."
            }else {
                self.typingUserLbl.text = ""
            }
        }
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
    @IBAction func messageBoxClicked(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        if messageBoxTxt.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name,channelId)
        }else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.manager.defaultSocket.emit("startType", UserDataService.instance.name,channelId)
            }
            isTyping = true
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
                    SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name,channelId)
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
                    self.tableView.reloadData()
                }
            }
        }
    }

    func getMessage() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
}
