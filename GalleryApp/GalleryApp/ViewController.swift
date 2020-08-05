//
//  ViewController.swift
//  GalleryApp
//
//  Created by admin on 05/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    let apiInstance = PlacesAPI()
    var placeList:[Places] = []
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    func setUpNavigation() {
        navigationItem.title = "Navigation Bar"
        self.navigationController?.navigationBar.barTintColor =  .red
        self.navigationController?.navigationBar.isTranslucent = false
    
    }
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        self.getPlaces()
      }
    
    
 
    func getPlaces(){
        

        apiInstance.loadJson(fromURLString: Constants.dataURL) { (result) in
            switch result {
            case .success(let data):
                let response:(String, [Places]) = self.apiInstance.parse(jsonData: data)
                DispatchQueue.main.async {
                    self.navigationController?.topViewController?.navigationItem.title = response.0
                    self.placeList = response.1
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                }
               
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let indexItem = self.placeList[indexPath.row]
        cell.indexImageView.image = UIImage(named: "no_image")
        cell.nameLabel.text = indexItem.placeName
        cell.detailedLabel.text = indexItem.placeDescription
        cell.tag = indexPath.row
        if let _ = indexItem.imageURL{
        
        DispatchQueue.global(qos: .utility).async {
            
            URLSession.shared.dataTask(with: URL(string: indexItem.imageURL!)!) { (data, response, error) in
                
                if error != nil{
                  DispatchQueue.main.async {
                       cell.indexImageView.image = UIImage(named: "no_image")
                   }
                    return;
                }
                if (response as! HTTPURLResponse).statusCode == 404{
                    DispatchQueue.main.async {
                        cell.indexImageView.image = UIImage(named: "no_image")
                    }
                    return;
                }
                
                DispatchQueue.main.async() { () -> Void in
                    if cell.tag == indexPath.row{
                        cell.indexImageView.image = UIImage(data: data!)
                    }
                }
                }.resume()
            
        }
        }
        return cell

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return UITableView.automaticDimension
         
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         
            return 200
        
    }
}

