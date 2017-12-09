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
    
    func callAPILogin(with params: [String:Any], url: String , _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        let _header = createHeader("")
        NetworkService.requestWith(.post, url: url, parameters: params, header: _header) { (data, error, code) in
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
                completion(false, error!)
            }
        }
    }
    
    func callAPIForgotPass(with params: [String:Any], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWith(.post, url: Constant.APIKey.forgotPass, parameters: params, header: _header) { (data, error, code) in
            guard let completion = completion else { return }
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error!)
            }
        }
    }
    
    func callAPIUpdateRole(_ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.get, url: Constant.APIKey.updateRole, parameters: nil, header: _header) { (data, mess, code) in
            guard let completion = completion else { return }
            guard let code = code else { return }
            if code == StatusCode.success {
                completion(true, nil)
            } else {
                guard let error = mess else { return }
                completion(false, error)
            }
        }
    }
    
    func callAPILogOut(_ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.get, url: Constant.APIKey.logOut, parameters: nil, header: _header) { (data, error, code) in
            guard let completion = completion else { return }
            if error != nil {
                if let code = code {
                    if code == StatusCode.success {
                        USER?.logOut()
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                        completion(true, nil)
                    } else {
                        guard let err = error else { return }
                        completion(false, err)
                    }
                }
            }
        }
    }
    
    func callAPIChangePassword(_ params: [String:Any], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _header = createHeader(userToken)
        NetworkService.requestWithHeader(.post, url: Constant.APIKey.changePass, parameters: params, header: _header, Completion: { (data, error, code) in
            guard let completion = completion else { return }
            if let code = code {
                if code == StatusCode.success {
                    completion(true, nil)
                } else {
                    completion(false, error!)
                }
            }
        })
    }
    
    func callAPIEditProfile(_ param:[String:Any], _ imageName:String, _ imageProfile:[UIImage], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        NetworkService.callApiMultiPart(url: Constant.APIKey.updateProfile, withNames: [imageName], method: .post, images: imageProfile, parameters: param, headers: _headers, completion: { (data) in
            guard let completion = completion else { return }
            let jsonFormat = JSONFormat(data)
            let parser:ParseDataSignIn = ParseDataSignIn()
            if jsonFormat.status == "success" {
                let userData = jsonFormat.data
                print(userData)
                parser.fetchDataSignIn(data: userData)
                completion(true, jsonFormat.message)
            } else {
                completion(false, jsonFormat.message)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func callAPIGetListMotel(page:Int, _ completion:((_ success:Bool, _ mess:String?, _ arrMotel:[Motel], _ pagination:Pagination?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers = createHeader(userToken)
        let param = ["country":3,
                     "page":page
        ] as [String:Any]
        NetworkService.requestData(.get, url: Constant.APIKey.getListMotel, parameters: param, encoding: URLEncoding.default, headers: _headers) { (data, pagination,mess, code) in
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
                completion(false, mess, [], nil)
            }
        }
    }
}
