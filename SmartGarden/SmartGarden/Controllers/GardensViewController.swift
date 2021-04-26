//
//  GardensViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 06/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class GardensViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_new: UIButton!
    
    @IBAction func new(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewGarden", sender: nil)
    }
    
    @IBAction func goPlants(_ sender: UIButton) {
        self.performSegue(withIdentifier: "plantasSegue", sender: sender)
    }
    
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_new.layer.borderWidth = 1
        btn_new.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        logedIn()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "plantasSegue" {
            let destino = segue.destination as! PlantsViewController //ViewControllerB
            if let button = sender as? UIButton{
                destino.gardenID = button.tag
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any){
        debugPrint("Presionado")
        let headersnot401: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)", "Accept":"aplication/json"]
        Alamofire.request("https://api-smart-garden.herokuapp.com//logout", method: .post, parameters: ["Authentication":App.shared.tokensaved],headers: headersnot401).responseJSON{(response) -> Void in
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
    
    func logedIn(){
        let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)", "Accept":"application/json"]
        Alamofire.request("https://api-smart-garden.herokuapp.com/loggedIn", method: .get, headers: headers).responseData{(response) in
            guard let data = response.value else { return }
            do{
                let decoder = JSONDecoder()
                let userLog = try decoder.decode(UserLogged.self, from: data)
                
                print("ID BRO:", userLog.id)
                
                let width = 375
                let height = 150
                let spacing = 15
                var positionY = 200
                let heightS = 250
                
                self.getStoredGardens(idde: userLog.id, completionHandler: { (gardens) in
                    gardens.forEach({ (jardines) in
                        let gardenButton = GardenButton(frame: CGRect(x: 20, y: positionY, width: width, height: height))
                        gardenButton.configure(with: Button(id: jardines.id ,gardenName: "Nombre: "+jardines.name, gardenLocation: "Ubicación: "+jardines.location, gardenCreated: jardines.created_at))
                        gardenButton.tag = jardines.id
                        print(gardenButton.tag)
                        gardenButton.addTarget(self, action: #selector(self.goPlants(_:)), for: .touchUpInside)
                        self.scrollView.addSubview(gardenButton)
                        positionY += height + spacing
                    })
                    self.scrollView.contentSize = CGSize(width: 414, height: CGFloat(gardens.count * (heightS + spacing)))
                })
            }catch{
                print("Error \(error)")
            }
        }
    }
    
    func getStoredGardens(idde:Int, completionHandler: @escaping([GardensSaved])->Void){
        Alamofire.request("https://api-smart-garden.herokuapp.com/api/Garden/showByUser?id=\(idde)", method: .get).responseData(completionHandler: {(response) in
            guard let data = response.value else { return }
            do{
                print("xcosa", idde)
                let decoder = try  JSONDecoder().decode([GardensSaved].self , from: data)
                completionHandler(decoder)
                print(decoder)
            }catch{
                print("Error \(error)")
            }
        })
    }
    
    
}
