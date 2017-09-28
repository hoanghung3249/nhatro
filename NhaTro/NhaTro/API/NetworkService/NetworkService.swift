//
//  NetworkService.swift
//  NhaTro
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias success = (_ responseData: JSON?) -> Void
typealias failed = (_ error: String, _ code:Int?) -> Void

struct NetworkService {
    
    
    static func requestWith(_ requestType: Alamofire.HTTPMethod, url: String, parameters: Dictionary<String, Any>?, Completion:((_ data: [String: Any]?, _ error: String?, _ code:Int?) -> Void)?){
        let _headers: HTTPHeaders = ["Accept": "application/json"]
        
        Alamofire.request(url, method: requestType, parameters: parameters, encoding: JSONEncoding.default, headers: _headers).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(let value):
                guard let value = value as? [String: Any] else{
                    Completion!(nil, "Data is wrong format, Please contact server side.", nil)
                    return
                }
                if let status = value["status"] as? String{
                    if status == "success" {
                        if let data = value["data"] as? [String: Any], let code = value["status_code"] as? Int{
                            print(data)
                            Completion!(data, nil, code)
                        }else{
                            Completion!(["Success": "success"],nil,nil)
                        }
                    }else{
                        if let error = value["message"] as? String, let code = value["status_code"] as? Int {
                            //                            if let msg = error["msg"] as? String, let code = error["code"] as? Int {
                            //                                Completion!(nil, msg, code)
                            //                            }
                            Completion!(nil,error,code)
                        }
                    }
                }else{
                    Completion!(nil, "The Server is Unreachable, Please try again later.", nil)
                }
                break
                
            case .failure(let error):
                if(error._code == -1009) {
                    Completion!(nil, "No internet connection", -1009)
                } else {
                    Completion!(nil, error.localizedDescription, nil)
                }
                break
                
            }
        }
    }
    
    static func requestData(_ requestType: Alamofire.HTTPMethod, url: String, parameters: Dictionary<String, Any>?, Completion:((_ data: JSON?, _ error: String?, _ code:Int?) -> Void)?){
        let _headers: HTTPHeaders = ["Accept": "application/json"]
        
        Alamofire.request(url, method: requestType, parameters: parameters, encoding: JSONEncoding.default, headers: _headers).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(let value):
                guard let value = value as? [String: Any] else{
                    Completion!(nil, "Data is wrong format, Please contact server side.", nil)
                    return
                }
                if let status = value["status"] as? String{
                    if status == "success" {
                        if let data = value["data"] as? [[String: Any]], let code = value["status_code"] as? Int{
                            let dataJSON = JSON(data)
                            Completion!(dataJSON, nil, code)
                        }else{
                            Completion!([["Success": "success"]],nil,nil)
                        }
                    }else{
                        if let error = value["message"] as? String, let code = value["status_code"] as? Int {
                            Completion!(nil,error,code)
                        }
                    }
                }else{
                    Completion!(nil, "The Server is Unreachable, Please try again later.", nil)
                }
                break
                
            case .failure(let error):
                if(error._code == -1009) {
                    Completion!(nil, "No internet connection", -1009)
                } else {
                    Completion!(nil, error.localizedDescription, nil)
                }
                break
                
            }
        }
    }
    
    
    static func requestWithHeader(_ requestType: Alamofire.HTTPMethod,_ token:String ,url: String, parameters: Dictionary<String, Any>?, Completion:((_ data: [String: Any]?, _ error: String?, _ code:Int?) -> Void)?){
        let _headers: HTTPHeaders = ["Accept": "application/json",
                                     "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(url, method: requestType, parameters: parameters, encoding: JSONEncoding.default, headers: _headers).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(let value):
                guard let value = value as? [String: Any] else{
                    Completion!(nil, "Data is wrong format, Please contact server side.", nil)
                    return
                }
                print(value)
                if let status = value["status"] as? String{
                    if status == "success" {
                        if let data = value["data"] as? [String: Any], let code = value["status_code"] as? Int{
                            print(data)
                            Completion!(data, nil, code)
                        }else if let code = value["status_code"] as? Int, let mess = value["message"] as? String{
                            Completion!(["Success": "success"],mess,code)
                        } else {
                            Completion!(["Success": "success"],nil,nil)
                        }
                    }else{
                        if let error = value["message"] as? String, let code = value["status_code"] as? Int {
                            Completion!(nil,error,code)
                        }
                    }
                }else{
                    Completion!(nil, "The Server is Unreachable, Please try again later.", nil)
                }
                break
                
            case .failure(let error):
                if(error._code == -1009) {
                    Completion!(nil, "No internet connection", -1009)
                } else {
                    Completion!(nil, error.localizedDescription, nil)
                }
                break
                
            }
        }
    }
    
    
    static func callApiMultiPart(url: String, withNames: [String], method: Alamofire.HTTPMethod, images: [UIImage], parameters: [String : Any]?, headers: [String : String]?, completion: ((_ data : JSON) -> Void)?, failure: ((_ error : Error) -> Void)?){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for i in 0..<images.count{
                let image = images[i]
                let withName = withNames[i]
                let nameFile = UUID().uuidString
                
                
                let imgData: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.1)!)
                let imageSizeMB :Double = Double(imgData.length) / 1024.0 / 1024.0 //mb
                
                print("size of image in B = \(imageSizeMB)")
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.1)!, withName: withName, fileName: "\(nameFile).jpg", mimeType: "image/jpeg")
            }
            
            // import parameters
            if parameters != nil  {
                for (key, valueElement) in parameters! {
                    if valueElement is String || valueElement is Int {
                        multipartFormData.append("\(valueElement)".data(using: .utf8)!, withName: key)
                    }
                }
            }
        }, usingThreshold: UInt64.init(), to: url, method: method, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    //                    print(response.result.value)
                    switch response.result {
                    case .success(let data):
                        let responseDic = JSON(data)
                        print(responseDic)
                        completion!(responseDic)
                        break
                    case .failure(let error):
                        failure!(error)
                        break
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
}
