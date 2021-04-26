//
//  wsObject.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 25/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import Foundation

class wsDataRecived: Codable{
    
    let t: Int
    let d: DataWS
    
    internal init(t:Int, d:DataWS){
        self.t=t
        self.d=d
    }
}
