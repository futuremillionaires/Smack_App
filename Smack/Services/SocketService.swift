//
//  SocketService.swift
//  Smack
//
//  Created by Raju Dhumne on 05/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    override init() {
        super.init()
    }
    
 let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    func addChannel(channelName:String,channelDescription:String,completion:@escaping CompletionHandler){
        manager.defaultSocket.emit("newChannel", channelName,channelDescription)
        completion(true)
    }
    
    
    func getChannel(completion:@escaping CompletionHandler){
        manager.defaultSocket.on("channelCreated") { (dataArry, ack) in
            guard let channelName = dataArry[0] as? String else {return}
            guard let channelDescription = dataArry[1] as? String else {return}
            guard let channelId = dataArry[2] as? String else{return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
        
        
        
    }
    
    
}
