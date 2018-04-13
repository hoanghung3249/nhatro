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

class MapViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var viewGoogleMap: UIView!
    @IBOutlet weak var sldStep: G8SliderStep!
    @IBOutlet weak var btnShowPrice: UIButton!
    @IBOutlet weak var btnShowArea: UIButton!
    let dropDown = DropDown()
    
    fileprivate var mapView:GMSMapView?
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
    fileprivate var location: CLLocationCoordinate2D?
    fileprivate var arrMotel = [Motel]()
    fileprivate let imageMarker = UIImage(named: "homeLocationMarker")!
    fileprivate var limitRadius: Int = 1
    fileprivate var price: Int = 1
    fileprivate var autocompleteController:GMSAutocompleteViewController?
    fileprivate var isFilterPrice = true
    fileprivate let arrFilterPrice = ["Tất cả", "Dưới 5 triệu", "Trên 5 triệu"]
    fileprivate let arrFilterArea = ["1m²","3m²","5m²"]
    // Check to avoid call API
    fileprivate var isFinished = true
    
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
        navigationController?.navigationBar.tintColor = .white
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        backBtn.setImage(#imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), for: .normal)
        backBtn.addTarget(self, action: #selector(MapViewController.backView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Tìm kiếm"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        if let textSearch = searchBar.value(forKey: "_searchField") as? UITextField {
            textSearch.layer.cornerRadius = 10
            textSearch.clipsToBounds = true
        }
        navigationItem.titleView = searchBar
    }
    
    private func setupDropdown(_ anchorView: UIView, dataSource: [String]) {
        dropDown.anchorView = anchorView
        dropDown.direction = .bottom
        dropDown.cornerRadiusDPD = 10
        dropDown.borderWidth = 0.5
        dropDown.borderColor = .gray
        dropDown.shadowOpacity = 0.5
        dropDown.backgroundColor = .white
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.width = anchorView.frame.width
        dropDown.dataSource = dataSource
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else { return }
            if strongSelf.isFilterPrice {
                
            } else {
                
            }
        }
        
    }
    
    private func callAPIFilter(with limitRadius: Int, price: Int) {
        guard let location = location else { return }
        DataCenter.shared.callAPIFilterMotel(location: location, limitRadius: limitRadius, price: price) { [weak self] (success, mess, arrMotel) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.isFinished = true
                strongSelf.arrMotel.removeAll()
                strongSelf.arrMotel = arrMotel
                strongSelf.addMarker()
            } else {
                guard let mess = mess else { return }
                strongSelf.showAlert(with: mess)
            }
        }
    }
    
    private func direction() {
        guard let location = location else { return }
        let destination = CLLocationCoordinate2D(latitude: 10.841240, longitude: 106.664897)
        DataCenter.shared.direction(from: location, to: destination) { [weak self] (singleLine) in
            guard let strongSelf = self else { return }
            guard let singleLine = singleLine else { return }
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 14)
            DispatchQueue.main.async {
                strongSelf.mapView?.animate(to: camera)
                singleLine.map = strongSelf.mapView
            }
        }
    }
    
    //MARK:- Action buttons
    
    @objc func backView() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeSliderValue(_ sender: G8SliderStep) {
        if !sender.isTracking {
            let intValue = Int(round(sender.value))
            switch intValue {
            case 1:
                limitRadius = intValue
            case 2:
                limitRadius = intValue
            case 3:
                limitRadius = intValue
            default:
                limitRadius = 1
            }
        } else {
            if Int(sender.value) == 1 {
                limitRadius = Int(sender.value)
            } else if Int(sender.value) == 2 {
                limitRadius = Int(sender.value)
            } else if Int(sender.value) == 3 {
                limitRadius = Int(sender.value)
            }
        }
        if isFinished {
            isFinished = false
            callAPIFilter(with: limitRadius, price: price)
        }
    }
    
    @IBAction func showDropDownPrice(_ sender: UIButton) {
        print("show price")
        isFilterPrice = true
        setupDropdown(btnShowPrice, dataSource: arrFilterPrice)
        dropDown.show()
    }
    
    @IBAction func showDropDownArea(_ sender: UIButton) {
        print("show area")
//        isFilterPrice = false
//        setupDropdown(btnShowArea, dataSource: arrFilterArea)
//        dropDown.show()
        let selectRegionVC = Storyboard.main.instantiateViewController(ofType: SelectRegionViewController.self)
        selectRegionVC.isLoginView = false
        selectRegionVC.delegate = self
//        let navi = NhaTroNavigationVC(rootViewController: selectRegionVC)
//        navi.setupTitle("Chọn Khu Vực")
//        present(selectRegionVC, animated: true, completion: nil)
        navigationController?.pushViewController(selectRegionVC, animated: true)
    }
    
}

//MARK:- Setup Google Map
extension MapViewController: GMSMapViewDelegate {
    
     fileprivate func setupGoogleMap() {
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.viewGoogleMap.frame.size.width, height: self.viewGoogleMap.frame.size.height))
        mapView?.mapType = .terrain
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.delegate = self
        DispatchQueue.main.async {
            self.viewGoogleMap.insertSubview(self.mapView!, at: 0)
        }
        moveMapviewCamera()
    }
    
    private func moveMapviewCamera() {
        LocationManager.shared.getCurrentLocation { [weak self] (userLocation, err) in
            LocationManager.shared.stopUpdateLocation()
            guard let strongSelf = self else { return }
            if let userLocation = userLocation {
                let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 16)
                strongSelf.location = userLocation
                if strongSelf.isFinished {
                    strongSelf.isFinished = false
                    strongSelf.callAPIFilter(with: strongSelf.limitRadius, price: strongSelf.price)
                }
                DispatchQueue.main.async {
                    strongSelf.mapView?.animate(to: camera)
                }
            } else {
                print(err!)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let infoWindow = Bundle.main.loadNibNamed("InfoWinDow", owner: self.viewGoogleMap, options: nil)?.first as? InfoWinDowView else { return nil }
        if let motelMarker = marker.userData as? Motel {
            infoWindow.lblPrice.text = "\(motelMarker.unit_price) VNĐ"
            infoWindow.lblName.text = motelMarker.location
            infoWindow.lblPhone.text = motelMarker.phone
        }
        return infoWindow
    }
    
    fileprivate func addMarker() {
        guard let mapView = mapView else { return }
        DispatchQueue.main.async {
            mapView.clear()
        }
        arrMotel.forEach { [weak self] (motel) in
            guard let strongSelf = self else { return }
            let markerPosition = CLLocationCoordinate2D(latitude: motel.latitude, longitude: motel.longitude)
            let marker = GMSMarker(position: markerPosition)
            marker.icon = imageMarker
            marker.userData = motel
            DispatchQueue.main.async {
                marker.map = strongSelf.mapView
            }
        }
    }

}

// MARK: - Slider's setup
extension MapViewController{
     fileprivate func setupSlider() {
        let imgSlider = UIImage(named:"ovalCopy2")!
        sldStep.stepImages = [imgSlider, imgSlider, imgSlider]
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

// MARK: - Searchbar Delegate
extension MapViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar == self.searchBar {
            autocompleteController = GMSAutocompleteViewController()
            autocompleteController?.delegate = self
            DispatchQueue.main.async {
                self.present(self.autocompleteController!, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
}

// MARK: - GMSAutoComplete Delegate
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        location = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let address = place.formattedAddress {
            searchBar.text = address
        }
        if isFinished {
            isFinished = false
            callAPIFilter(with: limitRadius, price: price)
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - Select Region Delegate
extension MapViewController: SelectRegionDelegate {
    
    func dismissVC(with location: CLLocationCoordinate2D) {
        self.location = location
        self.searchBar.text = UserDefaults.string(forKey: .area)
        callAPIFilter(with: limitRadius, price: price)
    }
}
