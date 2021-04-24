//
//  GardenButton.swift
//  SmartGarden
//
//  Created by Eduardo Maldonado on 23/04/21.
//  Copyright © 2021 E-Nexus. All rights reserved.
//

import UIKit


struct Button{
    
    let id:Int
    let gardenName: String
    let gardenLocation: String
    let gardenCreated: String
}

final class GardenButton: UIButton {
    
    private let gardenID:Int = {
        let GardenID:Int = 0
        return GardenID
    }()
    
    private let name: UILabel = {
        let lb_name = UILabel()
        lb_name.numberOfLines = 1
        lb_name.textAlignment = .center
        lb_name.textColor = .white
        lb_name.font = .systemFont(ofSize: 20, weight: .bold)
        return lb_name
    }()
    
    private let location: UILabel = {
       let location = UILabel()
        location.numberOfLines = 1
        location.textAlignment = .left
        location.textColor = .white
        location.font = .systemFont(ofSize: 18, weight: .regular)
        return location
    }()
    
    private let created_at: UILabel = {
        let lb_created_at = UILabel()
        lb_created_at.numberOfLines = 1
        lb_created_at.textAlignment = .left
        lb_created_at.textColor = .white
        lb_created_at.font = .systemFont(ofSize: 15, weight: .regular)
        return lb_created_at
    }()
    
    private let image: UIImage = {
        var img_image = UIImage()
        img_image = UIImage(named: "plantas 2.png")!
        img_image.alignmentRectInsets.right
        return img_image
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        addSubview(name)
        addSubview(location)
        //addSubview(created_at)
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 1/2
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.4, blue: 0.1254901961, alpha: 0.63)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: Button){
        name.text = viewModel.gardenName
        location.text = viewModel.gardenLocation
        //created_at.text = viewModel.gardenCreated
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2)
        location.frame = CGRect(x: 15, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/2)
        //created_at.frame = CGRect(x: 0, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/2)
    }

}
