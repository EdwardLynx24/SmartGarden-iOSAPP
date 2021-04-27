//
//  NewSensorViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 18/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class NewSensorViewController: UIViewController {

    @IBOutlet weak var txf_nombre: UITextField!
    @IBOutlet weak var txf_tipo: UITextField!
    
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func newSensorButton(_ sender: Any) {
        self.addSensor()
    }
    func addSensor(){
        let nombre = txf_nombre.text!
        let tipo = txf_tipo.text!
        
        Alamofire.request("https://api-smart-garden.herokuapp.com/api/newSensor", method: .post, parameters: ["name":nombre, "type":tipo], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let JSON = response.result.value{
                print(JSON)
                self.performSegue(withIdentifier: "sensorAdded", sender: nil)
            }else{
                print("No se añadio el sensor")
            }
        }
        
    }
    
}
