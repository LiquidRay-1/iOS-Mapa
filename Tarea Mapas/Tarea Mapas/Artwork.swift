//
//  Artwork.swift
//  Tarea Mapas
//
//  Created by dam2 on 22/1/24.
//

import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let locationName: String
    let discipline: String
    var pinColor: UIColor
    
    var subtitle: String?{
        return locationName
    }
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, pinColor: UIColor) {
        self.coordinate = coordinate
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.pinColor = pinColor
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addresDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addresDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
