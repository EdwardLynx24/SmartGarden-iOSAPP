//
//  Info.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 26/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import Foundation

class Info:Codable{
    
    var humidity:String
    var temperature:String
    
    internal init(humidity:String,temperature:String){
        self.humidity = humidity
        self.temperature = temperature
    }
    
}
