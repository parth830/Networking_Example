//
//  SchoolDetailsViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/19/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit
import MessageUI

class SchoolDetailsViewController: UIViewController {

    @IBOutlet weak var emailButton: UIButton!
    
    var SATResults = [SATResultDataStruct]()

    let SATResultURL: String = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
    var detailDBN = String()
    var detailSchoolName = String()
    var phoneNumber = String()
    var emailId = String()
    var schoolLocation = String()
    var latitude = String()
    var longitude = String()

    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var numOfSATTakersLabel: UILabel!
    @IBOutlet weak var SATReadingScoreLabel: UILabel!
    @IBOutlet weak var SATMathScoreLabel: UILabel!
    @IBOutlet weak var SATWritingScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolNameLabel.text = self.detailSchoolName
        // Navigation Title
        title = "Details"
        setupSchoolNameLabel()
        getSATResultData()
        setupAddressLabel()
        setupEmailButton()
    }
    
    func setupEmailButton() {
        if emailId.isEmpty {
            emailButton.isEnabled = false
        }
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
    }
    
    func setupSchoolNameLabel() {
        schoolNameLabel.numberOfLines = 0
        schoolNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.schoolNameLabel.text = self.detailSchoolName
    }
    
    func setupAddressLabel() {
        if let location = schoolLocation.range(of: "(") {
            schoolLocation.removeSubrange(location.lowerBound..<schoolLocation.endIndex)
        }
    }
    
    func getSATResultData() {
        guard let url = URL(string: SATResultURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if error == nil {
                    self.SATResults = try JSONDecoder().decode([SATResultDataStruct].self, from: data!)
                    for result in self.SATResults {
                        if result.dbn == self.detailDBN {
                            DispatchQueue.main.async {
                                self.numOfSATTakersLabel.text = "Test Takers: \(result.num_of_sat_test_takers ?? "Result not found" )"
                                self.SATReadingScoreLabel.text = "Reading: \(result.sat_critical_reading_avg_score ?? "Result not found" )"
                                self.SATMathScoreLabel.text = "Math: \(result.sat_math_avg_score ?? "Result not found" )"
                                self.SATWritingScoreLabel.text = "Writing: \(result.sat_writing_avg_score ?? "Result not found" )"
                            }
                        }
                        
                    }
                    
                }
            } catch {
                print("Error in getting data from server.")
            }
        }.resume()
    }
    
    // MARK: - Call Button Tapped
    @IBAction func callTapped(_ sender: UIButton) {
        // Remove Special Character from Phone Number
        phoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(number)
        } else {
            UIApplication.shared.openURL(number)
        }
        print("Dailing a number")

    }
    
    //MARK: - Email Button Tapped
    @IBAction func EmailTapped(_ sender: UIButton) {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
       
        mailVC.setToRecipients([emailId])
        mailVC.setSubject("Subject")
        mailVC.setMessageBody("Sent From App", isHTML: false)
        
        self.present(mailVC, animated: true, completion: nil)
        
    }
    
    // MARK: - Show School Map View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MapViewController {
            destinationVC.schoolAddress = schoolLocation
            destinationVC.schoolName = detailSchoolName
            destinationVC.latitude = latitude
            destinationVC.longitude = longitude
        }
    }
}

// MARK: - Mail Composer Delegate
extension SchoolDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss Mail View Controller
        controller.dismiss(animated: true, completion: nil)
    }
}
