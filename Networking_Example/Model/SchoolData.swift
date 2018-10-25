//
//  File.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 9/28/18.
//  Copyright © 2018 parth. All rights reserved.
//

import Foundation

struct schoolDataStruct: Decodable{
    let school_name: String
    let city: String
    let dbn: String
    let phone_number: String
    let school_email: String?
    let location: String
    let latitude: String?
    let longitude: String?
    
//    let primary_address_line_1: String
//    let state_code: String
//    let zip: String
}
