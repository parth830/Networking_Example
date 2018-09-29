//
//  ViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 9/28/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var schoolTableView: UITableView!
    
    var schoolDataArray = [schoolDataStruct]()
    let schoolDataURL: String = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolTableView.rowHeight = 70
        getDataFromURL()
    }

    func getDataFromURL() {
        let url = URL(string: schoolDataURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                if error == nil {
                    self.schoolDataArray = try JSONDecoder().decode([schoolDataStruct].self, from: data!)
                        DispatchQueue.main.async {
                            self.schoolTableView.reloadData()
                        }
                }
            }catch {
                print("Error in getting data from server.")
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schoolDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SchoolDataTableViewCell = schoolTableView.dequeueReusableCell(withIdentifier: "cellId") as! SchoolDataTableViewCell
        cell.schoolNameLabel.text = "School: \(schoolDataArray[indexPath.row].school_name)"
        cell.schoolCityLabel.text = "City: \(schoolDataArray[indexPath.row].city)"
        return cell
    }
}

