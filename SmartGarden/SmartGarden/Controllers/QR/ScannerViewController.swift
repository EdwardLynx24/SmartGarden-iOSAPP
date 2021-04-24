//
//  ScannerViewController.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 18/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput:AVCaptureDeviceInput
        
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            return
        }
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else{
            failed()
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.qr]
        }else{
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.addSublayer(previewLayer)
        
        captureSession.startRunning()

    }
    func failed(){
        let alert = UIAlertController(title: "Escaner no soportado", message: "El dispositivo no puede usar un scaner QR o que no estes emulando como yo", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func readCorrect(string: String){
        print(string)
        if let data = string.data(using: .utf8){
            let decoder = JSONDecoder()
            guard let Planta = try? decoder.decode(Planta.self, from: data) else {fatalError("Error en la serializacion")}
            let alertPlanta = UIAlertController(title: "Maceta", message: "\(Planta)", preferredStyle: .alert)
            alertPlanta.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                alertPlanta.dismiss(animated: true, completion: nil)
            }))
            self.present(alertPlanta, animated: true, completion: nil)
        }else{
            print("Error de maceta")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            readCorrect(string: stringValue)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !captureSession.isRunning{
            captureSession.startRunning()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if captureSession.isRunning {
            captureSession.stopRunning()
            self.performSegue(withIdentifier: "goAddPlant", sender: nil)
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}
