//
//  RegisterViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 05/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//https://api-smart-garden.herokuapp.com/

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txf_name: UITextField!
    @IBOutlet weak var txf_mail: UITextField!
    @IBOutlet weak var txf_passConfirm: UITextField!
    @IBOutlet weak var txf_pass: UITextField!
    @IBOutlet weak var txf_lastname: UITextField!
    
    //let users = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txf_name.layer.cornerRadius = 10
        txf_lastname.layer.cornerRadius = 10
        txf_mail.layer.cornerRadius = 10
        txf_pass.layer.cornerRadius = 10
        txf_passConfirm.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    @IBAction func regist(_ sender: Any) {
        self.verify()
    }
    //Metodo para verificar datos
    func verify(){
        debugPrint("Presionado")
        let txfName = txf_name.text!
        let txfLastName = txf_lastname.text!
        let txfMail = txf_mail.text!
        let txfPass = txf_pass.text!
        let txfPassConfirm = txf_passConfirm.text!
        
        //Verificar que los datos no esten vacios
        if txfName.isEmpty || txfMail.isEmpty || txfPass.isEmpty || txfLastName.isEmpty{
            let alertEmptyString = UIAlertController(title: "Faltan Datos", message: "Alguno de los campos estan vacios", preferredStyle: .alert)
            alertEmptyString.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in alertEmptyString.dismiss(animated: true, completion: nil)}))
            self.present(alertEmptyString, animated: true, completion: nil)
            txf_name.shake()
            txf_lastname.shake()
            txf_mail.shake()
            txf_pass.shake()
            txf_passConfirm.shake()
            debugPrint("Llegue hasta donde fallo porque no hay datos")
        }else if txfPass == txfPassConfirm{
            let state = self.isValidEmail(txfMail)
            if state == false{
                let alertWrongEmail = UIAlertController(title: "Correro electronico invalido", message: "Verifica que el correo electronica cumpla con el formato example@example.example", preferredStyle: .alert)
                alertWrongEmail.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    alertWrongEmail.dismiss(animated: true, completion: nil)
                }))
                self.present(alertWrongEmail, animated: true, completion: nil)
            }else{
                self.registerUser()
                self.performSegue(withIdentifier: "RegisterSuccessfull", sender: nil)
            }
        }
            //Verificar que las contraseñas sean iguales
        else if txfPass != txfPassConfirm{
            let alertDifferentePassword = UIAlertController(title: "Las contraseñas no coinciden", message: "Las contraseñas ingresadas no coinciden, no son iguales", preferredStyle: .alert)
            alertDifferentePassword.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in alertDifferentePassword.dismiss(animated: true, completion: nil)}))
            self.present(alertDifferentePassword, animated: true, completion: nil)
            txf_pass.shake()
            txf_passConfirm.shake()
            debugPrint("Llegue hasta donde las contraseñas fallaron")
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func registerUser(){
        
        let txfName = txf_name.text!
        let txfLastName = txf_lastname.text!
        let txfMail = txf_mail.text!
        let txfPass = txf_pass.text!
        
        Alamofire.request("https://api-smart-garden.herokuapp.com//register", method: .post, parameters: ["name":txfName,"lastName":txfLastName,"email":txfMail,"password":txfPass], encoding: JSONEncoding.default).responseJSON { (response) in
            self.performSegue(withIdentifier: "RegisterSuccessfull", sender: nil)
        }
    }
}
