//
//  PlantsButton.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 24/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit

struct ButtonPlant{
    
    let id:Int
    let plantname:String
    let plantspice:String
}

final class PlantsButton: UIButton {
    
    private let plantID:Int = {
        let PlantID:Int = 0
        return PlantID
    }()
    
    private let name: UILabel = {
        let lb_name = UILabel()
        lb_name.numberOfLines = 1
        lb_name.textAlignment = .center
        lb_name.textColor = .white
        lb_name.font = .systemFont(ofSize: 20, weight: .bold)
        return lb_name
    }()
    
    private let spice: UILabel = {
        let spice = UILabel()
        spice.numberOfLines = 1
        spice.textAlignment = .left
        spice.textColor = .white
        spice.font = .systemFont(ofSize: 18, weight: .regular)
        return spice
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        addSubview(name)
        addSubview(spice)
        //addSubview(created_at)
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 1/2
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.5490196078, blue: 0.168627451, alpha: 0.55)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: ButtonPlant){
        name.text = viewModel.plantname
        spice.text = viewModel.plantspice
        //created_at.text = viewModel.gardenCreated
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2)
        spice.frame = CGRect(x: 15, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/2)
    }

}


