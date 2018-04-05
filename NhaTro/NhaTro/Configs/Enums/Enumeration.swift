//
//  Enumeration.swift
//  NhaTro
//
//  Created by HOANGHUNG on 3/9/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import Foundation

public enum Region: String {
    case bac = "Bac"
    case trung = "Trung"
    case nam = "Nam"
}

enum DefaultValueKeys: String {
    case isSendMailActive       = "isSendMailActive"
    case isUserActived          = "isUserActived"
    case isRegionSelected       = "isRegionSelected"
    case region                 = "region"
    case area                   = "area"
}
