//
//  ViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 9/28/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var schoolTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    // MARK: - Properties
    var schoolsData = [schoolDataStruct]()
    var filterSchoolsData = [schoolDataStruct]()
    let schoolDataURL: String = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getSchoolsData()
        setupNavBar()
        setupSearchBar()
        setupScopeBar()
        schoolTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteButton.isEnabled = false
        favoriteButton.isEnabled = true
    }

    // MARK: - Helper Methods
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
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Setup the Search Controller
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search School"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Setup the Scope Bar
    func setupScopeBar() {
        searchController.searchBar.scopeButtonTitles = ["Name", "City"]
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Filter Data
    func filterContentForSearchText(_ searchText: String, scope: String = "Name") {
        filterSchoolsData = schoolsData.filter({( school : schoolDataStruct) -> Bool in
            if scope == "City" {
                return school.city.lowercased().contains(searchText.lowercased())
            }
            return school.school_name.lowercased().contains(searchText.lowercased())
        })
        schoolTableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
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
        schoolDetail.schoolWebsite = school.website
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
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let wordCount = searchBar.text!.count
        if wordCount > 2 {
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        }
        else {
            if !isFiltering() {
                schoolTableView.reloadData()
            }
        }
    }
}

// MARK: - UISearchbar Delegate for Scope bar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
}

