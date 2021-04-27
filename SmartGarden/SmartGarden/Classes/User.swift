//
//  User.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 12/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import Foundation

struct User: Decodable{
    
    let email:String
    let password:String
    
    init(_ email:String, _ password:String){
        self.email = email
        self.password = password
    }
    
}
