//
//  SchoolDetailsViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/19/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit

class SchoolDetailsViewController: UIViewController {

    var SATResults = [SATResultDataStruct]()

    let SATResultURL: String = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
    var detailDBN = String()
    var detailSchoolName = String()

    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var numOfSATTakersLabel: UILabel!
    @IBOutlet weak var SATReadingScoreLabel: UILabel!
    @IBOutlet weak var SATMathScoreLabel: UILabel!
    @IBOutlet weak var SATWritingScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolNameLabel.text = self.detailSchoolName
        title = "SAT Exam Details"
        setupSchoolNameLabel()
        getSATResultData()
        
    }
    
    func setupSchoolNameLabel() {
        schoolNameLabel.numberOfLines = 0
        schoolNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.schoolNameLabel.text = self.detailSchoolName
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
}
