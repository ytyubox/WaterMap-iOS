//
//  MapKit+.swift
//  WaterMap
//
//  Created by 游宗諭 on 2019/12/8.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import Foundation
import MapKit


class LandmarkAnnotation: NSObject, MKAnnotation {
	let title: String?
	let subtitle: String?
	let coordinate: CLLocationCoordinate2D
	var lat:Double {coordinate.latitude}
	var lon:Double {coordinate.longitude}
	init(title: String?,
		 subtitle: String?,
		 coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate
	}
	init?(title: String?,
		  subtitle: String?,
		  lat:Double?,
		  lon:Double?) {
		guard
			let lat = lat,
			let lon = lon
			else {return nil}
		self.title = title
		self.subtitle = subtitle
		self.coordinate = .init(latitude: lat, longitude: lon)
	}
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
	var mapViewController: MapView
	private static let data = try! Data(contentsOf: URL(string: "https://watermap.teia.tw/waterdrop.png")!)
	private static let image = UIImage(data: MapViewCoordinator.data)
	init(_ control: MapView) {
		self.mapViewController = control
	}
	
	func mapView(_ mapView: MKMapView,
				 viewFor annotation: MKAnnotation) -> MKAnnotationView?{
    if annotation is 	MKUserLocation {return nil}
		let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
		annotationView.canShowCallout = true
		//Your custom image icon
		annotationView.image =  Self.image
		return annotationView
	}
}

