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
    
    @IBOutlet weak var lb_temp: UILabel!
    @IBOutlet weak var lb_humidy: UILabel!
    @IBOutlet weak var lb_plantName: UILabel!
    let headers: HTTPHeaders = ["Authorization":"Bearer \(App.shared.tokensaved)","Accept":"aplication/json"]
    var plantID:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ID de planta: \(self.plantID)")
        getPlantData()
        self.wsConector()
        // Do any additional setup after loading the view.
    }
    
    func wsConector(){
        
        var request = URLRequest(url: URL(string: "ws://chat-api-for-python-v0.herokuapp.com/adonis-ws")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
    }

    func onReceivedData(_ d:String){
        if let data = d.data(using: .utf8){
            let decoder = JSONDecoder()
            
            do{
                let wsobject = try decoder.decode(wsDataRecived.self, from: data)
                print(wsobject.d.data)
                self.lb_humidy.text = wsobject.d.data
            }catch{
                print("Decoder error")
            }
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("Conectado a tu culito")
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
        let params = ["t":1,"d":["topic":"chat"]] as [String : Any]
        guard JSONSerialization.isValidJSONObject(params) else { fatalError("JSON Invalid") }
        do{
            let data = try JSONSerialization.data(withJSONObject: params)
            socket.write(data: data) {
                completion()
            }
        }catch{
            print(error)
        }
    }
    
    
    func getPlantData(){
        
        Alamofire.request("https://smart-garden-api-v12.herokuapp.com/api/Flowerpot/show?id=\(self.plantID)", method: .get, headers: headers).responseData { (response) in
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
    
    

}
