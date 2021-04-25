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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "plantData" {
            let destino = segue.destination as! PlantDataViewController //ViewControllerB
            if let button = sender as? UIButton{
                destino.plantID = button.tag
            }
        }
    }
    
    func getStoredPlants(completionHandler: @escaping([Planta])->Void){
        Alamofire.request("https://smart-garden-api-v12.herokuapp.com/api/Flowerpot/showByGarden?garden=\(self.gardenID)", method: .get).responseData(completionHandler: {(response) in
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
