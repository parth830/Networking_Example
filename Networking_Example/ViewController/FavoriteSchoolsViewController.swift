//
//  FavoriteSchoolsViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/24/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit
import CoreData

class FavoriteSchoolsViewController: UIViewController {

    @IBOutlet weak var favoriteSchoolsTableView: UITableView!
    
    var favoriteSchool: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Title
        title = "Favorite School"
        favoriteSchoolsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteSchool")
        
        do {
            favoriteSchool = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

// MARK: - Table View Delegate and Datasource
extension FavoriteSchoolsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteSchool.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let school = favoriteSchool[indexPath.row]
        let cell = favoriteSchoolsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = school.value(forKeyPath: "schoolName") as? String
        cell.detailTextLabel?.text = school.value(forKeyPath: "schoolDbn") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favSchoolDetail:SchoolDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "deailsVC") as! SchoolDetailsViewController
       
        let favSchool: NSManagedObject = favoriteSchool[indexPath.row]
        
        favSchoolDetail.detailDBN = (favSchool.value(forKeyPath: "schoolDbn") as? String) ?? ""
        favSchoolDetail.detailSchoolName = (favSchool.value(forKeyPath: "schoolName") as? String) ?? ""
        favSchoolDetail.phoneNumber = (favSchool.value(forKeyPath: "schoolPhone") as? String) ?? ""
        favSchoolDetail.emailId = (favSchool.value(forKeyPath: "schoolEmail") as? String) ?? ""
        favSchoolDetail.schoolLocation = (favSchool.value(forKeyPath: "schoolLocation") as? String) ?? ""
        favSchoolDetail.latitude = (favSchool.value(forKeyPath: "schoolLatitude") as? String) ?? ""
        favSchoolDetail.longitude = (favSchool.value(forKeyPath: "schoolLongitude") as? String) ?? ""
        favSchoolDetail.schoolWebsite = (favSchool.value(forKeyPath: "schoolWebsite") as? String) ?? ""
        
        self.navigationController?.pushViewController(favSchoolDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(favoriteSchool[indexPath.row] )
            favoriteSchool.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            favoriteSchoolsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
