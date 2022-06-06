//
//  ViewThree.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI
import MapKit
import CoreLocation



struct ViewThree: View {
    @State var openMapView = false
    @State var coordinates: CLLocation? = nil
    @StateObject var manager = LocationManager()
    @State var street = ""
    @State var annotationItem = ""
    @State var delegate = Heher()

    class Heher: NSObject, MKMapViewDelegate {

        var street: String = ""

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            getAddressFromLatLon(pdblLatitude: mapView.region.center.latitude.description, withLongitude: mapView.region.center.longitude.description)
//            print(street)
        }
        

    }
    
    init() {
        
        MKMapView.appearance().mapType = .standard
        MKMapView.appearance().showsUserLocation = true
        MKMapView.appearance().delegate = delegate
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Button {
                openMapView = true
            } label: {
                if !delegate.street.isEmpty {
//                    Text("\(coordinates.coordinate.latitude), \(coordinates.coordinate.longitude)")
                    Text(delegate.street)
                } else {
                    Text("set location")
                }
            }
            
            .fullScreenCover(isPresented: $openMapView) {
                ZStack {
                    MapSearchView(region: $manager.region).ignoresSafeArea()
//                    Map(coordinateRegion: $manager.region).ignoresSafeArea()
//                        .onChange(of: manager.region.center.latitude) { newValue in
//                            print("1")
//                        }
                    Image("Vector")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.red)
                        .padding(.bottom, 16)
                    VStack {
                        HStack {
                            Button {
                                openMapView = false
                            } label: {
                                Image(systemName: "arrowshape.turn.up.left.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                            }.padding()
                            Spacer()
                        }
                        Spacer()
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "pin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                Text(delegate.street)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Button {
                                coordinates = .init(latitude: manager.region.center.latitude, longitude: manager.region.center.longitude)
//                                street = delegate.street
//                                getAddressFromLatLon(pdblLatitude: manager.region.center.latitude.description, withLongitude: manager.region.center.longitude.description)
                                openMapView = false
                            } label: {
                                ZStack {
                                    Color("Selected")
                                    Text("Set Location")
                                        .foregroundColor(.white)
                                }.frame(height: 48)
                                    .cornerRadius(24)
                                    .padding(.horizontal)
                            }
                        }
                        .frame(height: 124)
                        .background(Color("PageIndicatorBackground"))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                }
                
            }
        }
    }
    
    static func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//            var streetName = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
//                    print(pm.country, "1")
//                    print(pm.locality, "2")
//                    print(pm.subLocality, "3")
//                    print(pm.thoroughfare, "4")
//                    print(pm.postalCode, "5")
//                    print(pm.subThoroughfare, "6")
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                street = addressString
//                    print(addressString)
            }
        })
    }

}


class LocationManager: NSObject,CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        region.center = manager.location!.coordinate
        region.span = .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
    func heh() {
        //        print(manager.location!.coordinate.latitude, manager.location!.coordinate.longitude)
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude:  manager.location!.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //            locations.last.map {
        //                print($0.coordinate.latitude, $0.coordinate.longitude)
        //                region = MKCoordinateRegion(
        //                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
        //                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        //                )
        //            }
    }
    
}

//struct ViewThree_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewThree()
//    }
//}

class MapViewController: UIViewController, MKMapViewDelegate {
        
    var mapView: MKMapView!
    var region: MKCoordinateRegion!
    // MARK: - UIViewController's methods
//    var horizontalSta
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()

        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
//        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        self.view.addSubview(mapView)
        mapView.region = region
        mapView.mapType = .standard
//        mapView.showsUserLocation = true
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("heh2")
    }
}



struct MapSearchView: UIViewControllerRepresentable {
    
    @Binding var region: MKCoordinateRegion

    func makeUIViewController(context: UIViewControllerRepresentableContext<MapSearchView>) -> MapViewController {
        let mapController = MapViewController()
        mapController.region = region
        return mapController
    }
    func updateUIViewController(_ uiViewController: MapViewController,
                                context: UIViewControllerRepresentableContext<MapSearchView>) {
            uiViewController.mapView.region = region
    }
}
