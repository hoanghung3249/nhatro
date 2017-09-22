//
//  MapViewController.swift
//  NhaTro
//
//  Created by DUY on 9/21/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var sldStep: G8SliderStep!
    @IBOutlet weak var ViewGoogleMap: UIView!
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    var destinations = [VacationDestination(name: "Duy hands0me", location: CLLocationCoordinate2D(latitude: 10.785872,longitude: 106.641432), zoom: 18, price: "1.000.000", phone: "0962667632"),VacationDestination(name: "123 Quang Trung, P.11, Quận Gò Vấp", location: CLLocationCoordinate2D(latitude: 10.786515,longitude: 106.645262), zoom: 20, price: "2.000.000", phone: "01666502222")]
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupNavi()
        setupSlider()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGoogleMap()
    }
    
    
    //MARK:- Support functions
    private func setupNavi(){
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .plain, target: nil, action: nil)
    }


    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
    }
    
    
    //MARK:- Action buttons
    
    @IBAction func changeSliderValue(_ sender: G8SliderStep) {
//        if !sender.isTracking {
//            let intValue = Int(round(sender.value))
//            print(intValue)
//        } else {
//            if sender.value == 1 {
//                self.txvText.text = "First text"
//            } else if sender.value == 2 {
//                self.txvText.text = "Second text"
//            } else if sender.value == 3 {
//                self.txvText.text = "Third text"
//            }
//            else if sender.value == 4 {
//                self.txvText.text = "for text"
//            }
//            else if sender.value == 5 {
//                self.txvText.text = "five text"
//            }

        }
    
    }





//MARK:- Setup Google Map
extension MapViewController:GMSMapViewDelegate,CLLocationManagerDelegate{

    
     func setupGoogleMap(){
        _ = destinations
        let current = destinations.first
        let camera = GMSCameraPosition.camera(withLatitude: (current?.location.latitude)!,longitude: (current?.location.longitude)!, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.ViewGoogleMap.frame.size.width, height: self.ViewGoogleMap.frame.size.height), camera: camera)
        
        ViewGoogleMap.insertSubview(mapView, at: 0)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        //Creates a marker in the center of the map.
        for i in destinations {
            let marker = GMSMarker(position: i.location)
            marker.icon = UIImage(named: "homeLocationMarker")
            marker.userData = i
            marker.map = mapView
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("InfoWinDow", owner: self.ViewGoogleMap, options: nil)?.first as? InfoWinDowView
        if let des = marker.userData as? VacationDestination {
            infoWindow?.lblPrice.text = des.price
            infoWindow?.lblName.text = des.name
            infoWindow?.lblPhone.text = des.phone
        }
        
        return infoWindow
    }

}
extension MapViewController{
    
     func setupSlider() {
        sldStep.stepImages = [UIImage(named:"ovalCopy2")!, UIImage(named:"ovalCopy2")!,UIImage(named:"ovalCopy2")!,]
        sldStep.tickTitles = ["1km","3km","5km"]
        sldStep.minimumValue = 1
        
        sldStep.trackColor = Color.kLightGrayColor()
        sldStep.stepTickColor = Color.kLightGrayColor()
        sldStep.stepTickWidth = 20
        sldStep.stepTickHeight = 20
        sldStep.trackHeight = 6.0
        sldStep.trackColor = Color.kLightGrayColor()
        sldStep.value = 1
        sldStep.isContinuous = false
    }

}
    






