//
//  PlantDataViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 25/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import Alamofire
import Starscream

class PlantDataViewController: UIViewController,WebSocketDelegate,WebSocketPongDelegate{
    
    private var socket: WebSocket! = nil
    var state:Bool = false
    var status:Bool = false
    
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
    @IBOutlet weak var lb_Regar: UILabel!
    @IBOutlet weak var lb_Calor: UILabel!
    @IBOutlet weak var lb_temp: UILabel!
    @IBOutlet weak var lb_humidy: UILabel!
    @IBOutlet weak var lb_plantName: UILabel!
    
    var plantID:Int = 0
    var gardenID:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ID de planta: \(self.plantID)")
        getPlantData()
        self.wsConector()
        print(self.gardenID)
        self.lb_Calor.text = "Foco: Apagado"
        DispatchQueue.global().async {
            self.ping()
            sleep(300)
            while true{
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dropPlant" {
            let destino = segue.destination as! PlantsViewController
            destino.gardenID = self.gardenID
        }else if segue.identifier == "goPlantsAgain"{
            let destino = segue.destination as! PlantsViewController
            destino.gardenID = self.gardenID
        }
    }
    
    
    
    @IBAction func eliminarPlanta(_ sender: Any) {
        //dropPlant
        Alamofire.request("https://api-smart-garden.herokuapp.com/api/Flowerpot/delete", method: .delete, parameters: ["id":self.plantID], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let JSON = response.value{
                print(JSON)
                self.performSegue(withIdentifier: "dropPlant", sender: nil)
            }
        }
    }
    
    @IBAction func regar(_ sender: Any) {
        print("Soy regar")
        let alertRegada = UIAlertController(title: "Planta Regada", message: "Tu planta ha sido regada.", preferredStyle: .alert)
        alertRegada.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            alertRegada.dismiss(animated: true, completion: nil)
        }))
        self.present(alertRegada, animated: true, completion: nil)
        self.onAction(string: "regar"){
            print("jalo")
        }
        
    }

    func onAction(string:String, completion: @escaping ()->()){
        print("Soy action :D")
        let params = ["t":7,"d":["topic":"measures","event":"message","data":["order":string,"plantID":self.plantID]]] as [String : Any]
        let msg = "{\"t\":7,\"d\":{\"topic\":\"measures\",\"event\":\"message\",\"data\":{\"order\":\(string),\"plantID\":\(self.plantID)}}}"
        print("String o JSON: \(msg)")
        socket.write(string: msg)
        self.jsonToString(json: params as AnyObject)
    }
    
    @IBAction func iluminar(_ sender: Any) {
        print("Soy iluminar")
        self.state = !self.state
        print(self.state)
        if self.state == true{
            self.onAction(string: "iluminar") {
                print(self.state)
                print("Encender")
            }
            self.lb_Calor.text = String("Foco: Encendido")
        }else if self.state == false{
            self.onAction(string: "apagar") {
                print(self.state)
                print("Apagar")
            }
            self.lb_Calor.text = String("Foco: Apagado")
        }
    }
    func wsConector(){
        
        var request = URLRequest(url: URL(string: "ws://api-smart-garden.herokuapp.com/adonis-ws")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.pongDelegate = self
        socket.connect()
        
    }

    func onReceivedData(_ d:String){
        if let data = d.data(using: .utf8){
            let decoder = JSONDecoder()
            print("Vamos a decodificar la vaina")
            do{
                let wsobject = try decoder.decode(wsDataRecived.self, from: data)
                print(wsobject.d.data.temperature,wsobject.d.data.humidity)
                self.lb_temp.text = String(wsobject.d.data.temperature)+" ºC"
                self.lb_humidy.text = String(wsobject.d.data.humidity)+" %"
            }catch{
                print("Decoder error")
            }
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        wsTopic{
            print("Jalop")
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Adios guapo")
    }
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        print("Got pong! Maybe some data: \(String(describing: data?.count))")
        self.ping()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Mensajito papu: \(text)")
        let msg = "{\"t\":7,\"d\":{\"topic\":\"measures\",\"event\":\"message\",\"data\":{\"order\":string,\"plantID\":self.plantID}}}"
        print("String o JSON: \(msg)")
        self.onReceivedData(text)
        self.ping()
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        return
    }
    
    func wsTopic(completion: @escaping ()->()){
        let paramsTopic = ["t":1,"d":["topic":"measures"]] as [String : Any]
        guard JSONSerialization.isValidJSONObject(paramsTopic) else { fatalError("JSON Invalid") }
        do{
            let dataTopic = try JSONSerialization.data(withJSONObject: paramsTopic)
            socket.write(data: dataTopic) {
                completion()
            }
        }catch{
            print(error)
        }
    }
    
    
    func getPlantData(){
        Alamofire.request("https://api-smart-garden.herokuapp.com/api/Flowerpot/show?id=\(self.plantID)", method: .get, headers: headers).responseData { (response) in
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
    
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString!)
            socket.write(string:convertedString!)// <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
    }
    
    @objc func ping(){
        let paramsPing = ["t":8] as [String : Any]
        guard JSONSerialization.isValidJSONObject(paramsPing) else { fatalError("JSON Invalid") }
        do{
            let dataPing = try JSONSerialization.data(withJSONObject: paramsPing)
            socket.write(data: dataPing)
        }catch{
            print(error)
        }
    }
}
