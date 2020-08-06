//
//  ViewController.swift
//  GalleryApp
//
//  Created by admin on 05/08/20.
//  Copyright © 2020 deemsys. All rights reserved.
//

import UIKit
// MARK: - MVC Pattern View Class
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 /*
     -------
     Initialisers for TableView, Navigation Bar
     
     PlaceList Array holds data alone
     PlaceImageList Array holds image and index
     We can maintain single array with both information, But for some logic I am using 2 different array
     -------
     */
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    let apiInstance = PlacesAPI()
    var placeList:[Places] = []
    var placeImageList:[PlacesImage] = []
    
    var timer: Timer!
    var refreshBarButtonActivityIndicator: UIBarButtonItem!
    var refreshBarButton: UIBarButtonItem!
     // MARK: - Initial Design Setups
   /*
     -----
     Didload setup Navigation Bar Color and Title
     TableView Init and Auto layout
     Navigation Bar button item with refresh and reload icon
     -------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setUpNavigation()
        setupTableView()
    }
    func setUpNavigation() {
        barItemSetUp()
        navigationItem.title = "Loading..."
        self.navigationController?.navigationBar.barTintColor =  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    func barItemSetUp() {
        
        let image = UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal)
        refreshBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(startRefreshButton))
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        refreshBarButtonActivityIndicator = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
         
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
        self.startRefreshButton()
        self.getPlaces()
      }
    // MARK: - Refresh Button image after API execution
    func resetRefreshButton(){
        self.navigationItem.rightBarButtonItem = refreshBarButtonActivityIndicator
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.navigationItem.rightBarButtonItem = self.refreshBarButton
        }
    }
   @objc private func startRefreshButton(){
        self.navigationItem.rightBarButtonItem = refreshBarButtonActivityIndicator
        getPlaces()
    }
 // MARK: - API Call to read JSON Data
    /*
     ---------
     It Checks Network Status
     If network unavailable loads the data from local database
     Otherwise read json feed from the given url and Saves the resultant array to database
     Both case update UITableView with the data
     Finally stop the refresh animation and setback to reload image
     ----------
     */
    func getPlaces(){
        
        if Reachability.isConnectedToNetwork() == false{
            // NO INTERNET
           self.placeList =  DataBaseAccess.databaseDelegate.loadData()
            self.placeImageList =  DataBaseAccess.databaseDelegate.readImage()
            self.navigationController?.topViewController?.navigationItem.title = UserDefaults.standard.value(forKey: "navigationTitle") as? String
            self.tableView.reloadData()
            self.resetRefreshButton()
            return
        }

        apiInstance.loadJson(fromURLString: Constants.dataURL) { (result) in
            switch result {
            case .success(let data):
                let response:(String, [Places]) = self.apiInstance.parse(jsonData: data)
                
                DispatchQueue.main.async {
                    self.navigationController?.topViewController?.navigationItem.title = response.0
                    UserDefaults.standard.setValue(response.0, forKey: "navigationTitle")
                    UserDefaults.standard.synchronize()
                    self.placeList = response.1
                    DataBaseAccess.databaseDelegate.saveData(list:self.placeList)
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    self.resetRefreshButton()
                }
               
                
            case .failure(let error):
                print(error)
                 
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.resetRefreshButton()
            }
        }
    }
    
   
    // MARK: - TableView Delegates

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let indexItem = self.placeList[indexPath.row]
        cell.indexImageView.image = UIImage(named: "no_image")
        cell.nameLabel.text = indexItem.placeName
        cell.detailedLabel.text = indexItem.placeDescription
        cell.tag = indexPath.row
        if Reachability.isConnectedToNetwork() != true{
            let result = self.placeImageList.filter { (item) -> Bool in
                item.rowIndex == indexPath.row
            }
            if result.count > 0{
                if let x = result[0].imageData{
                    cell.indexImageView.image = UIImage(data: x )
                }else{
                    cell.indexImageView.image = UIImage(named: "no_image")
                }
            }
            
            return cell
        }
        if let _ = indexItem.imageURL {
            
        
            // GCD call for image download
        DispatchQueue.global(qos: .utility).async {
            
            URLSession.shared.dataTask(with: URL(string: indexItem.imageURL!)!) { (data, response, error) in
                
                if error != nil{
                  DispatchQueue.main.async {
                       cell.indexImageView.image = UIImage(named: "no_image")
                   }
                    return;
                }
                if (response as! HTTPURLResponse).statusCode != 200{
                    DispatchQueue.main.async {
                        cell.indexImageView.image = UIImage(named: "no_image")
                    }
                    return;
                }
                
                DispatchQueue.main.async() { () -> Void in
                    if cell.tag == indexPath.row{
                        cell.indexImageView.image = UIImage(data: data!)
                        self.placeImageList.append(PlacesImage(rowIndex: indexPath.row, imageData: data!))
                        DataBaseAccess.databaseDelegate.saveImage(withData: data!, forIndex: indexPath.row)
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

