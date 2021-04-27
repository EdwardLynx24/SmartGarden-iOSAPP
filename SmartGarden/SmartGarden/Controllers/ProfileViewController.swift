//
//  ProfileViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 07/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet weak var txf_name: UITextField!
    @IBOutlet weak var btn_acerca: UIButton!
    @IBOutlet weak var txf_email: UITextField!
    @IBOutlet weak var txf_lastName: UITextField!
    
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)", "Accept":"application/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func deleteProfile(_ sender: Any) {
        self.loggedIn()
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        
            Alamofire.request("https://api-smart-garden.herokuapp.com/loggedIn", method: .get, headers: headers).responseData{(response) in
                guard let data = response.value else { return }
                do{
                    let decoder = JSONDecoder()
                    let userLog = try decoder.decode(UserLogged.self, from: data)
                    self.getUserID(id: userLog.id)
                    //self.updateUser(id: userLog.id)
                }catch{
                    print("Error: \(error)")
                }
            }
        }
    
    func updateUser(id: Int,nameS:String,lastNameS:String,emailS:String){
        
        let nombreUP = txf_name.text!
        let apellidoUP = txf_lastName.text!
        let emailUP = txf_email.text!
        
        if nombreUP.isEmpty && apellidoUP.isEmpty{
            
            let state = self.isValidEmail(emailUP)
            
            if state == true{
                Alamofire.request("https://api-smart-garden.herokuapp.com/update", method: .put, parameters: ["id":id, "email":emailUP], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    print(response)
                    let alertSuccesEmail = UIAlertController(title: "Correo Actualizado", message: "Tu correo electronico ha cambiado satisfacoriamente a: "+emailUP, preferredStyle: .alert)
                    alertSuccesEmail.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        alertSuccesEmail.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertSuccesEmail, animated: true, completion: nil)
                }
            }else{
                let alertWrongEmail = UIAlertController(title: "Correo electronico invalido", message: "Verifica el correo electronico", preferredStyle: .alert)
                alertWrongEmail.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertWrongEmail.dismiss(animated: true, completion: nil)
                }))
                self.present(alertWrongEmail, animated: true, completion: nil)
            }
        }
            
        else if nombreUP.isEmpty && emailUP.isEmpty{
            Alamofire.request("https://api-smart-garden.herokuapp.com/update", method: .put, parameters: ["id":id, "lastName":apellidoUP], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response)
                let alertSuccesLastName = UIAlertController(title: "Apellido Actualizado", message: "Tu apellido ha cambiado satisfacoriamente a: "+apellidoUP, preferredStyle: .alert)
                alertSuccesLastName.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertSuccesLastName.dismiss(animated: true, completion: nil)
                }))
                self.present(alertSuccesLastName, animated: true, completion: nil)
            }
        }else if apellidoUP.isEmpty && emailUP.isEmpty{
            Alamofire.request("https://api-smart-garden.herokuapp.com/update", method: .put, parameters: ["id":id, "name":nombreUP], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response)
                let alertSuccesName = UIAlertController(title: "Nombre Actualizado", message: "Tu nombre ha cambiado satisfacoriamente a: "+nombreUP, preferredStyle: .alert)
                alertSuccesName.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertSuccesName.dismiss(animated: true, completion: nil)
                }))
                self.present(alertSuccesName, animated: true, completion: nil)
            }
        }else if emailUP.isEmpty{
            Alamofire.request("https://api-smart-garden.herokuapp.com/update", method: .put, parameters: ["id":id, "name":nombreUP,"lastName":apellidoUP], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response)
                let alertSuccesNameLast = UIAlertController(title: "Nombre y apellido Actualizados", message: "Tu nombre ha cambiado satisfacoriamente a: "+nombreUP+" y apellido a: "+apellidoUP, preferredStyle: .alert)
                alertSuccesNameLast.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertSuccesNameLast.dismiss(animated: true, completion: nil)
                }))
                self.present(alertSuccesNameLast, animated: true, completion: nil)
            }
        }else{
            let state = self.isValidEmail(emailUP)
            if state == true{
                Alamofire.request("https://api-smart-garden.herokuapp.com/update", method: .put, parameters: ["id":id, "name":nombreUP,"lastName":apellidoUP,"email":emailUP], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    print(response)
                    let alertSuccesAll = UIAlertController(title: "Datos Actualizados", message: "Tus datos han cambiado satisfactoriamente."+"Nombre: "+nombreUP+" Apellido:"+apellidoUP+" Correo: "+emailUP, preferredStyle: .alert)
                    alertSuccesAll.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        alertSuccesAll.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertSuccesAll, animated: true, completion: nil)
                }
            }else{
                let alertWrongEmail = UIAlertController(title: "Correo electronico invalido", message: "Verifica el correo electronico", preferredStyle: .alert)
                alertWrongEmail.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertWrongEmail.dismiss(animated: true, completion: nil)
                }))
                self.present(alertWrongEmail, animated: true, completion: nil)
            }
        }
    }
    
    func getUserID(id: Int){
        Alamofire.request("https://api-smart-garden.herokuapp.com/getUser/\(id)", method: .get, headers: headers).responseData { (response) in
            guard let data = response.value else { return }
            do{
                let decoder = try JSONDecoder().decode(UserForLog.self, from: data)
                self.updateUser(id: id, nameS: decoder.name, lastNameS: decoder.lastName, emailS: decoder.email)
            }catch{
                print("Error: \(error)")
            }
        }
    }
    func loggedIn(){
        Alamofire.request("https://api-smart-garden.herokuapp.com/loggedIn", method: .get, headers: headers).responseData{(response) in
            guard let data = response.value else { return }
            do{
                let decoder = JSONDecoder()
                let userLog = try decoder.decode(UserLogged.self, from: data)
                self.deleteProfileID(idD: userLog.id)
            }catch{
                print("Error: \(error)")
            }
        }
    }
    func deleteProfileID(idD:Int){
        Alamofire.request("https://api-smart-garden.herokuapp.com/delete", method: .delete, parameters: ["id":idD], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let JSON = response.result.value{
                print(JSON)
                self.performSegue(withIdentifier: "profileDeleted", sender: nil)
            }else{
                print("Nada")
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

