//
//  ViewController.swift
//  Sensores 4b
//
//  Created by Juan  Sanchez on 30/3/16.
//  Copyright © 2016 Juan  Sanchez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    var distancia : Double = 0.0

    private let manejador = CLLocationManager()
    var punto1 = CLLocationCoordinate2D()
    var pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.distanceFilter = 50 // solo recibir lecturas con variacion de 50 metros
        manejador.requestWhenInUseAuthorization()
        
        punto1.latitude = 0
        punto1.longitude = 0
        
        

        
        mapa.showsScale = true
        mapa.showsCompass = true
        
        // let distancia = dePosicion.distanceFromLocaton(aPosicion) // entre puntos cllocation
        
        

    }

    func locationManager(manager: CLLocationManager, var didUpdateLocations locations: [CLLocation]) {
        var punto2 = CLLocationCoordinate2D()
        let pin2 = MKPointAnnotation()
        punto2.latitude = manager.location!.coordinate.latitude
        punto2.longitude = manager.location!.coordinate.longitude
        var distanciaTmp = 0.0
        if punto1.latitude != 0 {
            let ptoOrigen = CLLocation(coordinate: punto1, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate())
            let ptoDestino = CLLocation(coordinate: punto2, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate())
            distanciaTmp = Double(ptoOrigen.distanceFromLocation(ptoDestino))
        }
        else {
            distanciaTmp = 0.0
        }
       
        
        distancia += distanciaTmp
        
        
        pin2.title = "Lat : \(punto2.latitude ) Long: \(punto2.longitude)"
        pin2.subtitle = "Distancia = \(round(distancia*100)/100) metros"
        pin2.coordinate = punto2
        
        mapa.addAnnotation(pin2)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(punto2, 500, 500)
        let ajusted = mapa.regionThatFits(region)
        mapa.setRegion(ajusted, animated: true)
        punto1 = punto2
        
    }
    

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
           manejador.startUpdatingLocation()
           mapa.showsUserLocation = true
            

            
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    
    @IBAction func btnTipoMapa(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapa.mapType =   MKMapType.Standard
        } else if sender.selectedSegmentIndex == 1 {
            mapa.mapType =   MKMapType.Satellite
        } else {
            mapa.mapType =   MKMapType.Hybrid
        }
    }


}

