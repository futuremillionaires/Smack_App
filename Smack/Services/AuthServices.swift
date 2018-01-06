//
//  AuthServices.swift
//  Smack
//
//  Created by Raju Dhumne on 01/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AuthServices {
    
    static let instance = AuthServices()
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var authToken : String {
        
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userEmail: String {
        
        get {
            return defaults.value(forKey: USER_MAILS) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_MAILS)
        }
    }
    
    func registerUser(email:String,password:String,completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        let header = [
            "content-type": "application/json; charset=utf-8"
        ]
       
        let body: [String:Any] = [
            "email":lowerCaseEmail,
            "password":password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        
    }
    
    func userLogin(email:String,password:String,completion:@escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        let header = [
            "content-type": "application/json; charset=utf-8"
        ]
        
        let body: [String:Any] = [
            "email":lowerCaseEmail,
            "password":password
        ]
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data :data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    completion(true)
                    
                }catch {
                    debugPrint(error)
                }
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name: String,email: String,avatarName: String,avatarColor: String,completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String:Any] = [
            "name":name,
            "email":lowerCaseEmail,
            "avatarName":avatarName,
            "avatarColor":avatarColor,
            ]
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                do{
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    UserDataService.instance.setUserData(id: id, color: avatarColor, avatarName: avatarName, email: email, name: name)
                    completion(true)
                }catch{
                    debugPrint(error)
                }
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
        func findUserByEmail(completion: @escaping CompletionHandler){
            
            Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
                    guard let data = response.data else {return}
                    do{
                        let json = try JSON(data: data)
                        let id = json["_id"].stringValue
                        let avatarName = json["avatarName"].stringValue
                        let avatarColor = json["avatarColor"].stringValue
                        let email = json["email"].stringValue
                        let name = json["name"].stringValue
                        UserDataService.instance.setUserData(id: id, color: avatarColor, avatarName: avatarName, email: email, name: name)
                        
                    }catch{
                        debugPrint(error)
                    }
               completion(true)
            }
            
        }
        
    
    
        
    
    
}
    

