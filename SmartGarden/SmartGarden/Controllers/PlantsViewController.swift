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

    @IBOutlet weak var btn_new_plant: UIButton!
    
    var gardenID:Int = 0
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    let headers:HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
    @IBAction func goPlantData(_ sender: UIButton) {
        self.performSegue(withIdentifier: "plantData", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_new_plant.layer.cornerRadius = 15
        btn_new_plant.layer.borderWidth = 1
        btn_new_plant.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        buildButton()
    }
    @IBAction func addNewPlant(_ sender: Any) {
        //self.performSegue(withIdentifier: "addPlant", sender: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let headersnot401: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)", "Accept":"aplication/json"]
        Alamofire.request("https://api-smart-garden.herokuapp.com/logout", method: .post, parameters: ["Authentication":App.shared.tokensaved],headers: headersnot401).responseJSON{(response) -> Void in
            print(response)
            if let JSON = response.request?.value{
                self.performSegue(withIdentifier: "logOut", sender: nil)
            }else{
                let alertwronglogout = UIAlertController(title: "Fallo el Logout", message: "Token Incorrecto", preferredStyle: .alert)
                alertwronglogout.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in
                    alertwronglogout.dismiss(animated: true, completion: nil)
                }))
                self.present(alertwronglogout, animated: true, completion: nil)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plantData" {
            let destino = segue.destination as! PlantDataViewController
            if let button = sender as? UIButton{
                destino.plantID = button.tag
                destino.gardenID = self.gardenID
            }
        }else if segue.identifier == "addPlant"{
            let destino = segue.destination as! ScannerViewController
            destino.gardenID = self.gardenID
        }
    }
    
    func getStoredPlants(completionHandler: @escaping([Planta])->Void){
        
        print("Bob me llamo compi")
        print("Che mugrero \(self.gardenID)")
        Alamofire.request("https://api-smart-garden.herokuapp.com/api/Flowerpot/showByGarden?garden=\(self.gardenID)", method: .get, headers:headers).responseData(completionHandler: {(response) in
            guard let data = response.value else { return }
            do{
                let decoder = try JSONDecoder().decode([Planta].self , from: data)
                completionHandler(decoder)
                print(decoder)
            }catch{
                print("Error che \(error)")
            }
        })
    }
    
    func buildButton(){
        
        print("Si jala we, soy bob el constructor")
        
        let width = 375
        let height = 150
        let spacing = 15
        var positionY = 200
        let heightS = 250
        
        self.getStoredPlants { (Planta) in
            Planta.forEach({ (plantas) in
                
                let plantsButton = PlantsButton(frame: CGRect(x: 20, y: positionY, width: width, height: height))
                plantsButton.configure(with: ButtonPlant(id: plantas.id, plantname:"Nombre:"+plantas.name, plantspice: "Especie: "+plantas.spice))
                plantsButton.tag = plantas.id
                plantsButton.addTarget(self, action: #selector(self.goPlantData(_:)), for: .touchUpInside)
                self.scrollView.addSubview(plantsButton)
                positionY += height + spacing
            })
            self.scrollView.contentSize = CGSize(width: 414, height: CGFloat(Planta.count * (heightS + spacing)))
        }
    }
}
