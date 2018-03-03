//
//  DataCenter.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/5/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation
import GooglePlaces
import GoogleMaps
import Kingfisher

class DataCenter {
    
    static let shared = DataCenter()
    
    private func createHeader(_ userToken: String) -> HTTPHeaders {
        if userToken.isEmpty {
            let _header: HTTPHeaders = ["Accept": "application/json",
                                        "MT-API-KEY": "\(Constant.APIKey.secretKey)"
                                        ]
            return _header
        } else {
            let _header: HTTPHeaders = ["Accept": "application/json",
                                        "Authorization": "Bearer \(userToken)",
                                        "MT-API-KEY": "\(Constant.APIKey.secretKey)"
                                        ]
            return _header
        }
    }
    
    private func createHeaderDirection() -> HTTPHeaders {
        let _header: HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept": "application/json"
                                    ]
        return _header
    }
    
    private func returnMessage(with error: String) -> String {
        var messReturn = error
        if messReturn == ErrorMessage.cannotConnect {
            messReturn = ErrorMessage.cannotConnectVN
        }
        return messReturn
    }
    
    func callAPILogin(with params: [String:Any], url: String , _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        let _header = createHeader("")
        NetworkService.requestWith(.post, url: url, parameters: params, header: _header) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            let parser:ParseDataSignIn = ParseDataSignIn()
            if error == nil {
                if let data = data {
                    let dataJSON = JSON(data)
                    print(dataJSON)
                    parser.fetchDataSignIn(data: dataJSON)
                    completion(true, nil)
                }
            } else {
                completion(false, strongSelf.returnMessage(with: error!))
            }
        }
    }
    
    func callAPIForgotPass(with params: [String:Any], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWith(.post, url: Constant.APIKey.forgotPass, parameters: params, header: _header) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, strongSelf.returnMessage(with: error!))
            }
        }
    }
    
    func callAPIUpdateRole(_ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.get, url: Constant.APIKey.updateRole, parameters: nil, header: _header) { [weak self] (data, mess, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            guard let code = code else { return }
            if code == StatusCode.success {
                completion(true, nil)
            } else {
                guard let error = mess else { return }
                completion(false, strongSelf.returnMessage(with: error))
            }
        }
    }
    
    func callAPILogOut(_ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.get, url: Constant.APIKey.logOut, parameters: nil, header: _header) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if error != nil {
                if let code = code {
                    if code == StatusCode.success {
                        USER?.logOut()
                        KingfisherManager.shared.cache.clearMemoryCache()
                        Utilities.shared.removeCache()
                        completion(true, nil)
                    } else {
                        guard let err = error else { return }
                        completion(false, strongSelf.returnMessage(with: err))
                    }
                }
            }
        }
    }
    
    func callAPIChangePassword(_ params: [String:Any], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.post, url: Constant.APIKey.changePass, parameters: params, header: _header, Completion: { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if let code = code {
                if code == StatusCode.success {
                    completion(true, nil)
                } else {
                    completion(false, strongSelf.returnMessage(with: error!))
                }
            }
        })
    }
    
    func callAPIEditProfile(_ param:[String:Any], _ imageName:String, _ imageProfile:[UIImage], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        guard let completion = completion else { return }
        NetworkService.callApiMultiPart(url: Constant.APIKey.updateProfile, withNames: [imageName], method: .post, images: imageProfile, parameters: param, headers: _headers, completion: { [weak self] (data) in
            guard let strongSelf = self else { return }
            let jsonFormat = JSONFormat(data)
            let parser:ParseDataSignIn = ParseDataSignIn()
            if jsonFormat.status == "success" {
                let userData = jsonFormat.data
                print(userData)
                parser.fetchDataSignIn(data: userData)
                completion(true, jsonFormat.message)
            } else {
                completion(false, strongSelf.returnMessage(with: jsonFormat.message))
            }
        }) { (error) in
            print(error.localizedDescription)
            completion(false, error.localizedDescription)
        }
    }
    
    func callAPIGetListMotel(page:Int, _ completion:((_ success:Bool, _ mess:String?, _ arrMotel:[Motel], _ pagination:Pagination?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        let param = ["country":3,
                     "page":page
        ] as [String:Any]
        NetworkService.requestData(.get, url: Constant.APIKey.getListMotel, parameters: param, encoding: URLEncoding.default, headers: _headers) { [weak self] (data, pagination,mess, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if mess == nil {
                var arrMotel = [Motel]()
                guard let dataJSON = data?.arrayValue, let pagination = pagination else { return }
                let paging = Pagination(pagination)
                for motelJSON in dataJSON {
                    let motel = Motel(motelJSON)
                    print(motel)
                    arrMotel.append(motel)
                }
                completion(true, nil, arrMotel, paging)
            } else {
                guard let mess = mess else { return }
                completion(false, strongSelf.returnMessage(with: mess), [], nil)
            }
        }
    }
    
    func callAPIFilterMotel(location: CLLocationCoordinate2D, limitRadius: Int, price: Int, _ completion:((_ success:Bool, _ mess:String?, _ arrMotel:[Motel]) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        let param = ["limit": limitRadius,
                     "unit_price": price,
                     "latitude": location.latitude,
                     "longitude": location.longitude
            ] as [String:Any]
        NetworkService.requestData(.get, url: Constant.APIKey.getListFilter, parameters: param, encoding: URLEncoding.default, headers: _headers) { [weak self] (data, pagination, mess, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if mess == nil {
                var arrMotel = [Motel]()
                guard let dataJSON = data?.arrayValue else { return }
                for motelJSON in dataJSON {
                    let motel = Motel(motelJSON)
                    arrMotel.append(motel)
                }
                completion(true, nil, arrMotel)
            } else {
                guard let mess = mess else { return }
                completion(false, strongSelf.returnMessage(with: mess), [])
            }
        }
    }
    
    func callAPIPostHostel(with param: [String:Any], arrImage:[UIImage], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        let arrImg = createArrImage(arrImage)
        let arrImgName = createImagesName(arrImg)
        guard let completion = completion else { return }
        NetworkService.callApiMultiPart(url: Constant.APIKey.postMotel, withNames: arrImgName, method: .post, images: arrImg, parameters: param, headers: _header, completion: { [weak self] (data) in
            guard let strongSelf = self else { return }
            let jsonFormat = JSONFormat(data)
            print(jsonFormat)
            if jsonFormat.status == "success" {
                completion(true, nil)
            } else {
                completion(false, strongSelf.returnMessage(with: jsonFormat.message))
            }
        }) { (error) in
            completion(false, error.localizedDescription)
        }
    }
    
    func direction(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (_ point: GMSPolyline?) -> ()) {
        let urlString = "\(Constant.googleURLDirection)?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&units=metric&sensor=true&key=\(Constant.googleDirectionKey)"
        
        let header = createHeaderDirection()
        NetworkService.requestAPIDirection(urlString, header: header) { (points, mess) in
            if let points = points {
                let path = GMSPath(fromEncodedPath: points)
                let singleLine = GMSPolyline(path: path)
                singleLine.strokeWidth = 7
                singleLine.strokeColor = Color.mainColor()
                completion(singleLine)
            } else {
                guard let mess = mess else { return }
                print(mess)
            }
        }
    }
    
    func getListUserMotel(page:Int, _ completion:((_ success:Bool, _ mess:String?, _ arrMotel:[Motel], _ pagination:Pagination?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        let param = ["page":page] as [String:Any]
        NetworkService.requestData(.get, url: Constant.APIKey.getListUserMotel, parameters: param, encoding: URLEncoding.default, headers: _headers) { [weak self] (data, pagination,mess, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if mess == nil {
                var arrMotel = [Motel]()
                guard let dataJSON = data?.arrayValue, let pagination = pagination else { return }
                let paging = Pagination(pagination)
                for motelJSON in dataJSON {
                    let motel = Motel(motelJSON)
                    print(motel)
                    arrMotel.append(motel)
                }
                completion(true, nil, arrMotel, paging)
            } else {
                guard let mess = mess else { return }
                completion(false, strongSelf.returnMessage(with: mess), [], nil)
            }
        }
    }
    
    func deleteUserMotel(with id: Int, _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        let params = ["id": id] as [String: Any]
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.post, url: Constant.APIKey.deleteUserMotel, parameters: params, header: _header, Completion: { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if let code = code {
                if code == StatusCode.success {
                    completion(true, nil)
                } else {
                    completion(false, strongSelf.returnMessage(with: error!))
                }
            }
        })
    }
    
    func getListUserLike(page:Int, _ completion:((_ success:Bool, _ mess:String?, _ arrMotel:[Motel], _ pagination:Pagination?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        let param = ["page":page] as [String:Any]
        NetworkService.requestData(.get, url: Constant.APIKey.getListUserLike, parameters: param, encoding: URLEncoding.default, headers: _headers) { [weak self] (data, pagination,mess, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if mess == nil {
                var arrMotel = [Motel]()
                guard let dataJSON = data?.arrayValue, let pagination = pagination else { return }
                let paging = Pagination(pagination)
                for motelJSON in dataJSON {
                    let motel = Motel(motelJSON)
                    print(motel)
                    arrMotel.append(motel)
                }
                completion(true, nil, arrMotel, paging)
            } else {
                guard let mess = mess else { return }
                completion(false, strongSelf.returnMessage(with: mess), [], nil)
            }
        }
    }
    
    func likeOrUnlikeMotel(with id: Int, isLike: Bool = true,_ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        let params = ["id": id] as [String: Any]
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        var url = Constant.APIKey.likeMotel
        if !isLike {
            url = Constant.APIKey.unlikeMotel
        }
        NetworkService.requestWithHeader(.get, url: url, parameters: params, header: _header, encoding: URLEncoding.default, Completion: { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if let code = code {
                if code == StatusCode.success {
                    completion(true, nil)
                } else {
                    completion(false, strongSelf.returnMessage(with: error!))
                }
            }
        })
    }
    
    func getListRoomMotel(page:Int, _ completion:((_ success:Bool, _ mess:String?, _ arrMotel:[MotelRoom], _ pagination:Pagination?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        let param = ["page":page] as [String:Any]
        NetworkService.requestData(.get, url: Constant.APIKey.getMotelRoom, parameters: param, encoding: URLEncoding.default, headers: _headers) { [weak self] (data, pagination,mess, code) in
            guard let strongSelf = self else { return }
            guard let completion = completion else { return }
            if mess == nil {
                var arrMotel = [MotelRoom]()
                guard let dataJSON = data?.arrayValue, let pagination = pagination else { return }
                let paging = Pagination(pagination)
                for motelJSON in dataJSON {
                    let motel = MotelRoom(motelJSON)
                    print(motel)
                    arrMotel.append(motel)
                }
                completion(true, nil, arrMotel, paging)
            } else {
                guard let mess = mess else { return }
                completion(false, strongSelf.returnMessage(with: mess), [], nil)
            }
        }
    }
    
    private func createArrImage(_ arrImg:[UIImage]) -> [UIImage] {
        let arrImage = arrImg.filter({ $0 != UIImage(named: "add_image")! })
        return arrImage
    }
    
    private func createImagesName(_ arrImage:[UIImage]) -> [String] {
        var arrImgName = [String]()
        for index in 0..<arrImage.count {
            let imgName = "sub\(index + 1)"
            arrImgName.append(imgName)
        }
        return arrImgName
    }
}
