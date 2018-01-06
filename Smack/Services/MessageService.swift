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
                    print(self.channels[0].name)
                }
            }
            catch {
                debugPrint(response.result.error as Any)
            }
            completion(true)
        }
    }
   
    
    
    
    
    
    
}
