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
    
    var schoolsData = [schoolDataStruct]()
    var filterSchoolsData = [schoolDataStruct]()
    let schoolDataURL: String = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSchoolsData()
        setupNavBar()
        setupSearchBar()
        schoolTableView.tableFooterView = UIView()
    }

    func getSchoolsData() {
        guard let url = URL(string: schoolDataURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if error == nil {
                    self.schoolsData = try JSONDecoder().decode([schoolDataStruct].self, from: data!)
                }
                DispatchQueue.main.async {
                    self.schoolTableView.reloadData()
                }
            } catch {
                print("Error in getting data from server.")
            }
        }.resume()
    }
    
    // MARK: - Setup Large Text In Navigation
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Setup the Search Controller
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search School Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filterSchoolsData = schoolsData.filter({( school : schoolDataStruct) -> Bool in
            return school.school_name.lowercased().contains(searchText.lowercased())
        })
        schoolTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}


// MARK: - Table View
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterSchoolsData.count
        }
        return self.schoolsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SchoolDataTableViewCell = schoolTableView.dequeueReusableCell(withIdentifier: "cellId") as! SchoolDataTableViewCell
        let school: schoolDataStruct
        if isFiltering() {
            school = filterSchoolsData[indexPath.row]
        } else {
            school = schoolsData[indexPath.row]
        }
        cell.schoolNameLabel.text = "School: \(school.school_name)"
        cell.schoolCityLabel.text = "City: \(school.city)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schoolDetail:SchoolDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "deailsVC") as! SchoolDetailsViewController
        let school: schoolDataStruct
        if isFiltering() {
            school = filterSchoolsData[indexPath.row]
        } else {
            school = schoolsData[indexPath.row]
        }
        schoolDetail.detailDBN = school.dbn
        schoolDetail.detailSchoolName = school.school_name
        schoolDetail.phoneNumber = school.phone_number
        schoolDetail.emailId = school.school_email ?? String()
        schoolDetail.schoolLocation = school.location
        schoolDetail.latitude = school.latitude ?? String()
        schoolDetail.longitude = school.longitude ?? String()
        self.navigationController?.pushViewController(schoolDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - Search Controller
extension ViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

