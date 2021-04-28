//
//  Data.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 25/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import Foundation

class DataWS: Codable {
    var data:Info
    init(data:Info){
        self.data = data
    }

}
