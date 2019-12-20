//
//  PlacesViewController.swift
//  Home-Salon
//
//  Created by harshitha on 13/09/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacesViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    
    @IBOutlet weak var currentlocationlbl: UILabel!
    
   
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 26.8034, longitude: 75.8178, zoom: 15.0)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 26.8034, longitude: 75.8178)
        marker.isDraggable = true
        marker.map = mapView
        self.mapView.delegate = self
        marker.isDraggable = true
        reverseGeocoding(marker: marker)
        marker.map = mapView
        
        self.mapView.delegate = self
        
    }
    
    //Mark: Marker methods
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        reverseGeocoding(marker: marker)
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    
    
    //Mark: Reverse GeoCoding
    
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                print("Response is = \(address)")
                print("Response is = \(lines)")
                
                currentAddress = lines.joined(separator: "\n")
                
            }
            marker.title = currentAddress
            marker.map = self.mapView
        }
    }
    
}
