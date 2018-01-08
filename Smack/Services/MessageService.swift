//
//  MessageService.swift
//  Smack
//
//  Created by Raju Dhumne on 07/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel: Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler){
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            do {
                guard let data = response.data else{return}
                if let json = try JSON(data:data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(name: name, description: description, id: id)
                        self.channels.append(channel)
                    }
                }
            }
            catch {
                debugPrint(response.result.error as Any)
            }
            NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
            completion(true)
        }
    }
    
    func findAllMessageForChannel(channelId: String, completion:@escaping CompletionHandler){
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method:.get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            self.clearMessage()
            guard let data = response.data else {return}
            do {
                if let json = try JSON(data: data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, id: id, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, channelId: channelId, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                }
            }catch {
                debugPrint(response.result.error as Any)
                completion(false)
            }
            completion(true)
        }
        
    }
    
    func clearMessage(){
        messages.removeAll()
    }
    func clearChannel() {
        channels.removeAll()
    }
    
    
    
    
    
    
    
}
