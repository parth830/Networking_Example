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
            
            // remove the deleted item from the `UITableView`
            favoriteSchoolsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
