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

class PlantDataViewController: UIViewController,WebSocketDelegate{
    
    private var socket: WebSocket! = nil
    
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    
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
        // Do any additional setup after loading the view.
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
        self.onAction(string: "regar"){
            print("jalo")
        }
        
    }

    func onAction(string:String, completion: @escaping ()->()){
        print("Soy action :D")
        let params = ["t":7,"d":["topic":"measures","event":"message","data":["order":string,"plantID":self.plantID]]] as [String : Any]
        let msg = "{\"t\":7,\"d\":{\"topic\":\"measures\",\"event\":\"message\",\"data\":{\"order\":string,\"plantID\":self.plantID}}}"
        socket.write(string: msg)
        self.jsonToString(json: params as AnyObject)
    }
    
    @IBAction func iluminar(_ sender: Any) {
        print("Soy iluminar")
        self.onAction(string: "iluminar"){
            print("Jalo")
        }
        
    }
    func wsConector(){
        
        var request = URLRequest(url: URL(string: "ws://api-smart-garden.herokuapp.com/adonis-ws")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
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
        return
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Mensajito papu: \(text)")
        self.onReceivedData(text)
        
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
}
