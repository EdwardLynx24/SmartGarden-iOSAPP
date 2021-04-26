//
//  ProfilePreviewViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 18/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class ProfilePreviewViewController: UIViewController {

    @IBOutlet weak var lb_nombre: UILabel!
    
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedIn()
    }
    func loggedIn(){
        Alamofire.request("https://api-smart-garden.herokuapp.com/loggedIn", method: .get, headers: headers).responseData{(response) in
            guard let data = response.value else { return }
            do{
                let decoder = JSONDecoder()
                let userLog = try decoder.decode(UserLogged.self, from: data)
                self.lb_nombre.text = "¡Hola! " + userLog.username
            }catch{
                print("Error: \(error)")
            }
        }
    }
}
