//
//  SimpleMapView.swift
//  TutorFind
//
//  Created by Andreas Loizides on 29/11/2021.
//

import SwiftUI
import MapKit

struct SimpleMapView: View {
	struct Place: Identifiable{
		
		let id = UUID()
		let long: Double
		let lat: Double
		var coordinate: CLLocationCoordinate2D {
			CLLocationCoordinate2D(latitude: lat, longitude: long)
		}
	}
	let longitude: Double
	let latitude: Double
	let delta: Double
	private let annotationItems: [Place]
	@State private var region: MKCoordinateRegion
	init(longitude: Double, latitude: Double, delta: Double = 0.005){
		self.longitude=longitude
		self.latitude=latitude
		self.delta=delta
		self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
		self.annotationItems = [Place(long: longitude, lat: latitude)]
	}
    var body: some View {
		Map(coordinateRegion: $region, annotationItems: annotationItems){pl in
			MapMarker(coordinate: pl.coordinate, tint: .blue)
		}
		.frame(width: 400, height: 300)
    }
}

struct SimpleMapView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMapView(longitude: 33.29930579944547, latitude: 35.10877832443404)
    }
}
