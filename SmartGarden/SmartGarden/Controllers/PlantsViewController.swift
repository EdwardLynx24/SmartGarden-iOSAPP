//
//  PlantsViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 06/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class PlantsViewController: UIViewController {

    @IBOutlet weak var txf_name_plant: UITextField!
    @IBOutlet weak var txf_tipo_plant: UITextField!
    @IBOutlet weak var txf_category_plant: UITextField!
    @IBOutlet weak var txf_name_category: UITextField!
    @IBOutlet weak var txf_climate_plant: UITextField!
    @IBOutlet weak var btn_new_plant: UIButton!
    @IBOutlet weak var btn_new_category: UIButton!
    
    var gardenID:Int = 0
    
    
    let headers:HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_new_plant.layer.cornerRadius = 15
        //btn_new_category.layer.cornerRadius = 15
        print("ID del jardin: \(self.gardenID)")

    }
    
    @IBAction func addNewPlant(_ sender: Any) {
        
        let namePlant = txf_name_plant.text!
        let spicePlant = txf_tipo_plant.text!
        let categoryPlant = txf_category_plant.text!
        
        if namePlant.isEmpty || spicePlant.isEmpty || categoryPlant.isEmpty{
            
            let alertEmptyPlants = UIAlertController(title: "Campos vacios", message: "Porfavor rellena todos los campos para añadir tu planta", preferredStyle: .alert)
            alertEmptyPlants.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                alertEmptyPlants.dismiss(animated: true, completion: nil)
            }))
            self.present(alertEmptyPlants, animated: true, completion: nil)
            self.txf_name_plant.shake()
            self.txf_tipo_plant.shake()
            self.txf_category_plant.shake()
            
        }else{
            print("Aqui va el codigo para registrar planta")
            self.performSegue(withIdentifier: "PlantAdded", sender: nil)
        }
        
    }//Termina accion añadir planta
    
    @IBAction func addNewCategory(_ sender: Any) {
        
        let nombreCat = self.txf_name_category.text!
        let climaCat = self.txf_climate_plant.text!
        
        if nombreCat.isEmpty || climaCat.isEmpty{
            
            let alertEmptyCategory = UIAlertController(title: "Campos vacios", message: "Porfavor llena ambos campos", preferredStyle: .alert)
            alertEmptyCategory.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                alertEmptyCategory.dismiss(animated: true, completion: nil)
            }))
            self.present(alertEmptyCategory, animated: true, completion: nil)
            self.txf_name_category.shake()
            self.txf_climate_plant.shake()
            
        }else{
            Alamofire.request("https://smart-garden-api-v12.herokuapp.com/api/newCategory", method: .post, parameters: ["name":nombreCat, "climate":climaCat], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if let JSON = response.value{
                    print(JSON)
                }
            }
        }
    }//Termina accion agregar categoria
}
