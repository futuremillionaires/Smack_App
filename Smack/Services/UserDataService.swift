//
//  UserDataService.swift
//  Smack
//
//  Created by Raju Dhumne on 02/01/18.
//  Copyright © 2018 Raju Dhumne. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id:String,color:String,avatarName:String,email:String,name:String){
        self.id = id
        self.email = email
        self.name = name
        self.avatarColor = color
        self.avatarName = avatarName
    }
    func setAvatarName(avatarName:String){
        self.avatarName = avatarName
    }
}
