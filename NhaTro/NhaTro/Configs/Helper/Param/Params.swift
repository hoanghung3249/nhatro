//
//  Params.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct Params {
    
    static func createParamLogin(_ email:String,_ pass:String) -> ([String:Any]?,String?) {
        var params:Dictionary<String,Any> = Dictionary()
        if email.isEmptyOrWhitespace() || pass.isEmptyOrWhitespace() {
            return (nil, "Xin nhập Email hoặc Password!")
        }
        if !email.isValidEmail() {
            return (nil, "Email không đúng định dạng!")
        }
        params.updateValue(email as Any, forKey: "email")
        params.updateValue(pass as Any, forKey: "password")
        
        return (params,nil)
    }
    
    static func createParamResgister(_ email:String,_ pass:String,_ phone:String,_ firstName:String,_ lastName:String,_ confirmPass:String) -> ([String:AnyObject]?,String?) {
        var params:Dictionary<String,AnyObject> = Dictionary()
        if email.isEmptyOrWhitespace() || pass.isEmptyOrWhitespace() || phone.isEmptyOrWhitespace() || firstName.isEmptyOrWhitespace() ||  lastName.isEmptyOrWhitespace() || confirmPass.isEmptyOrWhitespace()  {
            return (nil, "Xin nhập các trường yêu cầu!")
        }
        if !email.isValidEmail() {
            return (nil, "Email không đúng định dạng!")
        }
        if confirmPass != pass {
            return(nil , "Mật khẩu xác nhận không đúng với mật khẩu!")
        }
        if pass.count < 6 {
            return(nil,"Mật khẩu phải chứa ít nhất 6 kí tự!")
        }
        params.updateValue(email as AnyObject, forKey: "email")
        params.updateValue(pass as AnyObject, forKey: "password")
        params.updateValue(phone as AnyObject, forKey: "phone")
        params.updateValue(lastName as AnyObject, forKey: "last_name")
        params.updateValue(firstName as AnyObject, forKey: "first_name")
        return (params,nil)
    }

    static func createParamChangePass(_ newPass:String,_ confirmPass:String) -> ([String:AnyObject]?,String?) {
        var params:Dictionary<String,AnyObject> = Dictionary()
        
        if newPass.isEmptyOrWhitespace() || confirmPass.isEmptyOrWhitespace() {
            return (nil, "Xin hãy các trường yêu cầu!")
        }
        
        if confirmPass != newPass {
            return(nil ,"Mật khẩu xác nhận không đúng với mật khẩu!")
        }
        params.updateValue(newPass as AnyObject, forKey: "password")
        return(params,nil)
    }
    
    static func createParamUpdateProfile(_ phone:String, _ first_name:String, _ last_name:String, _ address:String, _ userLocation:CLLocationCoordinate2D) -> ([String:Any]?,String?) {
        var param = [String:Any]()
        if first_name.isEmptyOrWhitespace() || last_name.isEmptyOrWhitespace() || address.isEmptyOrWhitespace() || phone.isEmptyOrWhitespace() {
            return(nil, "Xin hãy nhập các trường yêu cầu!")
        }
        
        if !phone.isPhoneNumber {
            return(nil, "Số điện thoại không hợp lệ!")
        }
        
        param = [
            "phone":phone,
            "first_name":first_name,
            "last_name":last_name,
            "address":address,
            "latitude":userLocation.latitude,
            "longitude":userLocation.longitude
        ]
        return(param, nil)
    }
    
    static func createParamPostInfo(area:String, address:String, unitPrice:String, phone:String, description:String, location:CLLocationCoordinate2D) -> ([String:Any]?, String?) {
        var param = [String:Any]()
        if address.isEmptyOrWhitespace() {
            return (nil, "Xin hãy nhập địa chỉ!")
        }
        if area.isEmptyOrWhitespace() {
            return (nil, "Xin hãy nhập diện tích!")
        }
        if phone.isEmptyOrWhitespace() {
            return (nil, "Xin hãy nhập số điện thoại!")
        }
        if unitPrice.isEmptyOrWhitespace() {
            return (nil, "Xin hãy nhập giá phòng!")
        }
        param = [
            "location": address,
            "erea": area,
            "unit_price":unitPrice,
            "phone": phone,
            "description": description,
            "country": "3",
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        return (param, nil)
    }
}
