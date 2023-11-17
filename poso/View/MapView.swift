//
//  MapView.swift
//  POSO
//
//  Created by 박희경 on 2023/11/15.
//

import SwiftUI
import MapKit

/// The custom object I am referring to
class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

/// The delegate I am referring to
class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: MapView
    
    init(_ control: MapView) {
        self.mapViewController = control
    }
    
    func mapView(_ mapView: MKMapView, viewFor
                    annotation: MKAnnotation) -> MKAnnotationView?{
        // 마커 색상 설정
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.markerTintColor = .black
        annotationView.glyphImage = UIImage(systemName: "car")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
              let circleRenderer = MKCircleRenderer(circle: circleOverlay)
              circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1) // Set the fill color of the circle
              circleRenderer.strokeColor = UIColor.blue // Set the border color of the circle
              circleRenderer.lineWidth = 1 // Set the border width
              return circleRenderer
          }
          return MKOverlayRenderer(overlay: overlay)
    }
    
    /// This is where the delegate gets the object for the selected annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let v = view.annotation as? LandmarkAnnotation {
            print(v.coordinate)
        }
    }
}


struct MapView: UIViewRepresentable {
    
    var markers: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(
                                                latitude: 34.055404, longitude: -118.249278),CLLocationCoordinate2D(
                                                    latitude: 34.054097, longitude: -118.249664), CLLocationCoordinate2D(latitude: 34.053786, longitude: -118.247636)]
    var convertedMarkers: [LandmarkAnnotation] = []
    
    init() {
        convertedMarkers = cordToMark(locations: self.markers)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    func cordToMark(locations: [CLLocationCoordinate2D]) -> [LandmarkAnnotation] {
        var marks: [LandmarkAnnotation] = []
        for cord in locations {
            let mark = LandmarkAnnotation(title: "Test", subtitle: "Sub", coordinate: cord)
            marks.append(mark)
        }
        return marks
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.0537767, longitude: -118.248)
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coordinate
        mapCamera.pitch = 10
        mapCamera.altitude = 3000
        view.camera = mapCamera
        view.mapType = .mutedStandard
        view.delegate = context.coordinator
        view.addAnnotations(self.convertedMarkers)
        let radiusCircle = MKCircle(center: CLLocationCoordinate2D(
                                        latitude: 34.0537767, longitude: -118.248), radius: 300 as CLLocationDistance)
        view.addOverlay(radiusCircle)
        let locationCircle = MKCircle(center: CLLocationCoordinate2D(
                                        latitude: 34.0537767, longitude: -118.248), radius: 3 as CLLocationDistance)
        view.addOverlay(locationCircle)
    }
    
}