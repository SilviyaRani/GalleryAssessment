//
//  ViewController.swift
//  GalleryApp
//
//  Created by admin on 05/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    let placesapi = PlacesAPI()
    
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"]
    
    override func loadView() {
      super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        //placesapi.getPlaces()
        getData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      }
    
    
    func getData(){
      
        
        
//        let source = json.data(using: .utf8)!
//        let myResponse = try! JSONDecoder().decode(Data.self, from: source)
        

    }

}

