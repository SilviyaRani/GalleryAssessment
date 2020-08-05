//
//  CustomTableViewCell.swift
//  GalleryApp
//
//  Created by admin on 05/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell : UITableViewCell{
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let indexImageView:UIImageView = {
        let img = UIImageView(image: UIImage(named: "no_image"))
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
//        img.layer.cornerRadius = 35
//        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  .white
        label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let detailedLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor =  .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
   

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.contentView.addSubview(indexImageView)
//        containerView.addSubview(nameLabel)
//        containerView.addSubview(detailedLabel)
//        self.contentView.addSubview(containerView)
//
//        indexImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
//        indexImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
//        indexImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
//        indexImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
//
//        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
//        containerView.leadingAnchor.constraint(equalTo:self.indexImageView.trailingAnchor, constant:10).isActive = true
//        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
//       /containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
//
//        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
//        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
//        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
//
//        detailedLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
//        detailedLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
//        detailedLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
//        detailedLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
//
//
      self.contentView.addSubview(nameLabel)
          self.contentView.addSubview(indexImageView)
             
               self.contentView.addSubview(detailedLabel)
          
          nameLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 5).isActive = true
          nameLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 5).isActive = true
          nameLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -5).isActive = true
               
             
          indexImageView.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor, constant: 5).isActive = true
               indexImageView.leadingAnchor.constraint(equalTo:self.nameLabel.leadingAnchor).isActive = true
               indexImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
               indexImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
               
               
               
               
               detailedLabel.topAnchor.constraint(equalTo:self.indexImageView.bottomAnchor, constant: 5).isActive = true
               detailedLabel.leadingAnchor.constraint(equalTo:self.nameLabel.leadingAnchor).isActive = true
               detailedLabel.trailingAnchor.constraint(equalTo:self.nameLabel.trailingAnchor).isActive = true
        detailedLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant: -5).isActive = true
              
             
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
}