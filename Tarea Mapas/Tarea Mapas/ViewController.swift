//
//  ViewController.swift
//  Tarea Mapas
//
//  Created by dam2 on 22/1/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let estechChoords = CLLocationCoordinate2D(latitude: 38.09420601696138, longitude: -3.63124519770404)
    let estechURL = "https://escuelaestech.es"
    let positoChoords = CLLocationCoordinate2D(latitude: 38.09292631502212, longitude: -3.6349495423269844)
    let catedralChoords = CLLocationCoordinate2D(latitude: 37.9901227699412 , longitude: -3.468754691390374)
    let initialLocation = CLLocation(latitude: 38.09292631502212, longitude: -3.6349495423269844)
    let regionRadius: CLLocationDistance = 45000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        createAnnotation(title: "Escuela Estech", locationName: "Escuela de Tecnologias Aplicadas", discipline: "Linares", coordinate: estechChoords)
        createAnnotation(title: "El Pósito", locationName: "El Pósito de Linares", discipline: "Linares", coordinate: positoChoords)
        createAnnotation(title: "Catedral", locationName: "Catedral de Baeza", discipline: "Baeza", coordinate: catedralChoords)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotation(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        let artwork = Artwork(title: title, locationName: locationName, discipline: discipline, coordinate: coordinate, pinColor: .red)
        if discipline == "Linares" {
            artwork.pinColor = .red
        } else {
            artwork.pinColor = .yellow
        }
        mapView.addAnnotation(artwork)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            //view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        view.markerTintColor = annotation.pinColor
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let location = view.annotation as! Artwork
            var launchOptions: [String: Any]
            
            if location.discipline == "Linares" {
                launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            } else {
                launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            }
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
    }
