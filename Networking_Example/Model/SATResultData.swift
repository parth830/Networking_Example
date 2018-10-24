//
//  SATResultData.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/18/18.
//  Copyright © 2018 parth. All rights reserved.
//

import Foundation

struct SATResultDataStruct: Decodable {
    let num_of_sat_test_takers: String?
    let sat_critical_reading_avg_score: String?
    let sat_math_avg_score: String?
    let sat_writing_avg_score: String?
    let dbn: String?
}
