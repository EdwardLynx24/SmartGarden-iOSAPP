//
//  NewPlant&CategoryViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 24/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire
//import iOSDropDown

class NewPlant_CategoryViewController: UIViewController {

    @IBOutlet weak var btn_newPlant: UIButton!
    @IBOutlet weak var btn_newCategory: UIButton!
    @IBOutlet weak var txf_plantName: UITextField!
    @IBOutlet weak var txf_plantSpice: UITextField!
    @IBOutlet weak var txf_plantCategory: UITextField!
    @IBOutlet weak var txf_categoryName: UITextField!
    @IBOutlet weak var txf_categoryWeather: UITextField!
    
    // The list of array to display. Can be changed dynamically
    
    var gardenID:Int = 0
    
    var categoryID:String = ""
    
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn_newPlant.layer.cornerRadius = 15
        
        print("ID compi: \(self.gardenID)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "plantAdded" {
            let destino = segue.destination as! PlantsViewController //ViewControllerB
            destino.gardenID = self.gardenID
        }
    }
    
    @IBAction func addNewPlant(_ sender: Any) {
        
        let name = txf_plantName.text!
        let spice = txf_plantSpice.text!
        let category = txf_plantCategory.text!
        
        self.categoryID = category
        
        if name.isEmpty || spice.isEmpty || category.isEmpty{
            let alertEmptyData = UIAlertController(title: "Campos vacios", message: "Porfavor completa todos los campos", preferredStyle: .alert)
            alertEmptyData.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                alertEmptyData.dismiss(animated: true, completion: nil)
                self.txf_plantName.shake()
                self.txf_plantSpice.shake()
                self.txf_plantCategory.shake()
            }))
            self.present(alertEmptyData, animated: true, completion: nil)
        }else{
            if categoryID == "Tropical"{
                Alamofire.request("https://api-smart-garden.herokuapp.com/api/newFlowerpot", method: .post, parameters: ["name":name, "spice":spice,"garden":gardenID,"category":1], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    if let JSON = response.result.value{
                        print(JSON)
                        self.performSegue(withIdentifier: "plantAdded", sender: nil)
                    }
                }
            }else if categoryID == "Frio"{
                Alamofire.request("https://api-smart-garden.herokuapp.com/api/newFlowerpot", method: .post, parameters: ["name":name, "spice":spice,"garden":gardenID,"category":2], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    if let JSON = response.result.value{
                        print(JSON)
                        self.performSegue(withIdentifier: "plantAdded", sender: nil)
                    }
                }
            }else if categoryID == "Seco"{
                Alamofire.request("https://api-smart-garden.herokuapp.com/api/newFlowerpot", method: .post, parameters: ["name":name, "spice":spice,"garden":gardenID,"category":3], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    if let JSON = response.result.value{
                        print(JSON)
                        self.performSegue(withIdentifier: "plantAdded", sender: nil)
                    }
                }
            }else if categoryID == "Templado"{
                Alamofire.request("https://api-smart-garden.herokuapp.com/api/newFlowerpot", method: .post, parameters: ["name":name, "spice":spice,"garden":gardenID,"category":4], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    if let JSON = response.result.value{
                        print(JSON)
                        self.performSegue(withIdentifier: "plantAdded", sender: nil)
                    }
                }
            }else{
                let alertInvalidCategory = UIAlertController(title: "Categoria Invalida", message: "Porfavor introduce una categoria valida", preferredStyle: .alert)
                alertInvalidCategory.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertInvalidCategory.dismiss(animated: true, completion: nil)
                }))
                self.present(alertInvalidCategory, animated: true, completion: nil)
            }
        }
    }
    @IBAction func addNewCategory(_ sender: Any) {
        
        let name = txf_categoryName.text!
        let weather = txf_categoryWeather.text!
        
        if name.isEmpty || weather.isEmpty{
            let alertEmptyData = UIAlertController(title: "Campos vacios", message: "Porfavor rellena todos los campos", preferredStyle: .alert)
            alertEmptyData.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                alertEmptyData.dismiss(animated: true, completion: nil)
                self.txf_categoryName.shake()
                self.txf_categoryWeather.shake()
            }))
            self.present(alertEmptyData, animated: true, completion: nil)
        }else{
            Alamofire.request("https://api-smart-garden.herokuapp.com/api/newCategory", method: .post, parameters: ["name":name,"cimate":weather], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if let JSON = response.result.value{
                    print(JSON)
                }
            }
        }
    }
}
