//
//  ViewThree.swift
//  AnimatedTabBar
//
//  Created by Vasili on 25.04.22.
//

import SwiftUI
import MapKit
import CoreLocation
import Photos



struct ViewThree: View {
    @State var openMapView = false
    @State var coordinates: CLLocationCoordinate2D? = nil
    @StateObject var vm = MapViewModel()
    @State var street = ""
    @State var annotationItem = ""

    init() {
        MKMapView.appearance().mapType = .standard
        MKMapView.appearance().showsUserLocation = true
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("GradientTop"), Color("GradientBottom")], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Button {
                openMapView = true
            } label: {
                if !vm.addressLabel.isEmpty {
//                    Text("\(coordinates.coordinate.latitude), \(coordinates.coordinate.longitude)")
                    VStack {
                        Text(vm.addressLabel)
                        Text("\(coordinates?.latitude ?? 2) \(coordinates?.longitude ?? 2)")
                    }
                    
                } else {
                    Text("set location")
                }
            }
            
            .fullScreenCover(isPresented: $openMapView) {
                ZStack {
                    MapView(vm: vm).ignoresSafeArea()
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
                                Text(vm.addressLabel)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Button {
                                coordinates = .init(latitude: vm.centerCoordinate.latitude , longitude: vm.centerCoordinate.longitude)
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
                        .padding(.horizontal, 16)
                    }
                }
                
            }
        }
    }
    

}

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject{
    //All the variables live here
    @Published  var addressLabel: String = ""
    @Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @Published var currentLocation = MKCoordinateRegion()
    @Published var manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        currentLocation = .init(center: .init(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!), span: .init(latitudeDelta: 0.004, longitudeDelta: 0.004))
        manager.startUpdatingLocation()
    }
    
}

struct MapView: UIViewRepresentable {
    @ObservedObject var vm: MapViewModel
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            print("\(mapView.centerCoordinate.latitude), \(mapView.centerCoordinate.longitude)")
            parent.vm.centerCoordinate = mapView.centerCoordinate
        }
        
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
            getAddress(center: mapView.centerCoordinate)
        }
        //Gets the addess from CLGeocoder if available
        func getAddress(center: CLLocationCoordinate2D){
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: center.latitude, longitude: center.longitude)) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let _ = error {
                    //TODO: Show alert informing the user
                    print("error")
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    //TODO: Show alert informing the user
                    return
                }
                let city = placemark.locality ?? ""
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                
                DispatchQueue.main.async {
                    self.parent.vm.addressLabel =  String("\(streetName), \(streetNumber), \(city)")
                    print(self.parent.vm.addressLabel)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = vm.currentLocation
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
}
