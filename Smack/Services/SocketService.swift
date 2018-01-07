//
//  SocketService.swift
//  Smack
//
//  Created by Raju Dhumne on 07/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    override init() {
        super.init()
    }
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!,config:[.log(true),.compress])
    
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func terminateConnection() {
     manager.defaultSocket.disconnect()
    }
    
    func addChannel(name:String, description: String , completion: @escaping CompletionHandler) {
        manager.defaultSocket.emit("newChannel", name,description)
        completion(true)
    }
    
    func getChannel(completion : @escaping CompletionHandler) {
        manager.defaultSocket.on("channelCreated") { (dataArry, ack) in
            guard let name = dataArry[0] as? String else {return}
            guard let description = dataArry[1] as? String else {return}
            guard let id = dataArry[2] as? String else {return}
            let newChannel = Channel(name: name, description: description, id: id)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        manager.defaultSocket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    
    
    
}
