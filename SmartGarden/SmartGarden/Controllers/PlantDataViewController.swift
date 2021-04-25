//
//  PlantDataViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 25/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class PlantDataViewController: UIViewController {
    
    @IBOutlet weak var lb_plantName: UILabel!
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    var plantID:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ID de planta: \(self.plantID)")
        getPlantData()

        // Do any additional setup after loading the view.
    }
    
    func getPlantData(){
        
        Alamofire.request("https://smart-garden-api-v12.herokuapp.com/api/Flowerpot/show?id=\(self.plantID)", method: .get, headers: headers).responseData { (response) in
            guard let data = response.value else { return }
            do{
                let decoder = JSONDecoder()
                let plantData = try decoder.decode(ShowedPlant.self, from: data)
                print("Nombre: \(plantData.name)")
                self.lb_plantName.text = plantData.name
            }catch{
                print("Error: \(error)")
            }
        }
        
    }
    
    

}
