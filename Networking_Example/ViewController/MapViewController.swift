//
//  MapViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/24/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
   
    let regionRadius: CLLocationDistance = 1000
    var schoolAddress = String()
    var schoolName = String()
    var latitude = String()
    var longitude = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Title
        title = "Map"
        
        setupSchoolAddressLabel()
        
        let centerLocation = CLLocation(latitude: Double(latitude)!,longitude: Double(longitude)!)
        centerMapLocation(location: centerLocation)
        showSchoolOnMap()
    }
    
    func setupSchoolAddressLabel() {
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        addressLabel.text = schoolAddress
    }
    
    func centerMapLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showSchoolOnMap() {
        let schoolMap = SchoolMap(title: schoolName,locationName: schoolAddress, coordinate: CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!))
        mapView.addAnnotation(schoolMap)
    }

}
