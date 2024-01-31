//
//  ViewController.swift
//  Tarea Mapas
//
//  Created by dam2 on 22/1/24.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let estechChoords = CLLocationCoordinate2D(latitude: 38.09420601696138, longitude: -3.63124519770404)
    let estechURL = "https://escuelaestech.es"
    let positoChoords = CLLocationCoordinate2D(latitude: 38.09292631502212, longitude: -3.6349495423269844)
    let catedralChoords = CLLocationCoordinate2D(latitude: 37.9901227699412 , longitude: -3.468754691390374)
    let initialLocation = CLLocation(latitude: 38.09292631502212, longitude: -3.6349495423269844)
    let regionRadius: CLLocationDistance = 45000
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        createAnnotation(title: "Escuela Estech", locationName: "Escuela de Tecnologias Aplicadas", discipline: "Linares", coordinate: estechChoords)
        createAnnotation(title: "El Pósito", locationName: "El Pósito de Linares", discipline: "Linares", coordinate: positoChoords)
        createAnnotation(title: "Catedral", locationName: "Catedral de Baeza", discipline: "Baeza", coordinate: catedralChoords)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMapView(_:)))
            mapView.addGestureRecognizer(tapGesture)
        
        loadMarkers()
    }
    
    @objc func didTapMapView(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
        let alertController = UIAlertController(title: "Nuevo marcador", message: "Introduce los detalles del marcador", preferredStyle: .alert)
            
        alertController.addTextField { (textField) in
            textField.placeholder = "Título"
        }
            
        alertController.addTextField { (textField) in
            textField.placeholder = "Nombre de la ubicación"
        }
            
        alertController.addTextField { (textField) in
            textField.placeholder = "Lugar de la ubicación"
        }
        
        let confirmAction = UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let title = alertController.textFields?[0].text ?? "Sin título"
            let locationName = alertController.textFields?[1].text ?? "Sin nombre de ubicación"
            let discipline = alertController.textFields?[2].text ?? "Sin disciplina"

            let newMarker = Marker(context: self.context)
            newMarker.title = title
            newMarker.locationName = locationName
            newMarker.discipline = discipline
            newMarker.latitude = tappedCoordinate.latitude
            newMarker.longitude = tappedCoordinate.longitude
            try? self.context.save()

            self.createAnnotation(title: title, locationName: locationName, discipline: discipline, coordinate: tappedCoordinate)
            }
            
        let confirmAction = UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let title = alertController.textFields?[0].text ?? "Sin título"
            let locationName = alertController.textFields?[1].text ?? "Sin nombre de ubicación"
            let discipline = alertController.textFields?[2].text ?? "Sin disciplina"
            self.createAnnotation(title: title, locationName: locationName, discipline: discipline, coordinate: tappedCoordinate)
        }
            
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
            
        present(alertController, animated: true, completion: nil)
    }
    
    func loadMarkers() {
        let request: NSFetchRequest<Marker> = Marker.fetchRequest()

        do {
            let markers = try context.fetch(request)
            for marker in markers {
                let coordinate = CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude)
                createAnnotation(title: marker.title!, locationName: marker.locationName!, discipline: marker.discipline!, coordinate: coordinate)
            }
        } catch {
            print("Error al cargar los marcadores: \(error)")
        }
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
    
    func mapView(_ mapView: MKMapView, didTapMapView coordinate: CLLocationCoordinate2D) {
        createAnnotation(title: "Nuevo marcador", locationName: "Ubicación seleccionada", discipline: "Linares", coordinate: coordinate)
        }
    }
