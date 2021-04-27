//  LoginViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 05/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txf_mail: UITextField!
    @IBOutlet weak var txf_pass: UITextField!
    
    let token = UserDefaults.standard
    
    let defaults = UserDefaults.standard
    var state:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        txf_mail.layer.cornerRadius = 10
        txf_pass.layer.cornerRadius = 10
        print("Estado: \(self.state)")
        self.check()
        print("Estado: \(self.state)")
        // Do any additional setup after loading the view.
    }
    @IBAction func Login(_ sender: Any) {
        self.verify()
    }
    @IBAction func pushRegister(_ sender: Any) {
        //self.performSegue(withIdentifier: "GoToRegister", sender: nil)
    }
    func verify(){
        let txfmail = txf_mail.text!
        let txfpass = txf_pass.text!
        //Verificar que los campos no esten vacios
        if txfmail.isEmpty || txfpass.isEmpty{
            let alertEmptyString = UIAlertController(title: "Faltan Datos", message: "Alguno de los campos estan vacios", preferredStyle: .alert)
            alertEmptyString.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in alertEmptyString.dismiss(animated: true, completion: nil)}))
            self.present(alertEmptyString, animated: true, completion: nil)
            debugPrint("No funciono login")
            return
        }
            //Datos de login correctos
        else{
            self.logIn()
        }
    }
    func logIn(){
        let txfmail = txf_mail.text!
        let txfpass = txf_pass.text!
        
        let user = User(txfmail,txfpass)
        //self.check()
        //if self.state == false{
            Alamofire.request("https://api-smart-garden.herokuapp.com/login", method: .post, parameters: ["email":txfmail,"password":txfpass]).responseData { (response) in
                do {
                    guard let data = response.value else { return }
                    let decoder = JSONDecoder()
                    let auth = try decoder.decode(Auth.self, from: data)
                    //print(auth.token)
                    self.token.set(auth.token, forKey: "auth")
                    self.token.synchronize()
                    App.shared.tokensaved = auth.token
                    //
                    var userStored = self.getUsers()
                    userStored?.append(user)
                    let users:[User] = userStored?.count ?? 0 > 0 ? userStored!:[user]
                    do{
                        let jsonEncoder = JSONEncoder()
                        let data = try jsonEncoder.encode(users)
                        self.defaults.set(data, forKey: "users")
                        self.defaults.synchronize()
                    }catch{
                        print("No se pudo codificar")
                    }
                    //
                    self.performSegue(withIdentifier: "LoginSuccessfull", sender: nil)
                }catch {
                    print("Error en la serializacion \(error):")
                    let alertWrongLogin = UIAlertController(title: "Error de Login", message: "Verifica que los datos sean correctos", preferredStyle: .alert)
                    alertWrongLogin.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in alertWrongLogin.dismiss(animated: true, completion: nil)}))
                    self.present(alertWrongLogin, animated: true, completion: nil)
                    self.token.removeObject(forKey: "auth")
                }
            }
        //}
    }
    
    func check(){
        if let data = defaults.object(forKey: "users") as? Data{
            do{
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
                users.forEach { (user) in
                    print(user.email)
                    print(user.password)
                    Alamofire.request("https://api-smart-garden.herokuapp.com/login", method: .post, parameters: ["email":user.email,"password":user.password], encoding: JSONEncoding.default).responseData(completionHandler: { (response) in
                        guard let dataL = response.value else { return }
                        do{
                            let decoder = JSONDecoder()
                            let auth = try decoder.decode(Auth.self, from: dataL)
                            self.token.set(auth.token, forKey: "auth")
                            self.token.synchronize()
                            App.shared.tokensaved = auth.token
                            self.performSegue(withIdentifier: "LoginSuccessfull", sender: nil)
                        }catch{
                            print("No se pudo")
                        }
                    })
                    //self.defaults.removeObject(forKey: "users")
                }
                self.state = false
            }catch{
                print("Error en la serializacion \(error):")
                let alertWrongLogin = UIAlertController(title: "Error de Login", message: "Verifica que los datos sean correctos", preferredStyle: .alert)
                alertWrongLogin.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in alertWrongLogin.dismiss(animated: true, completion: nil)}))
                self.present(alertWrongLogin, animated: true, completion: nil)
                self.token.removeObject(forKey: "auth")
            }
        }
    }
    
    func getUsers() -> [User]?{
        do{
            let decoder = JSONDecoder()
            if let data = defaults.object(forKey: "users") as? Data{
                return try decoder.decode([User].self, from: data)
            }
        }catch{
            print("No fue posible la decoficación")
        }
        return nil
    }
    
}
