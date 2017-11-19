//
//  Pagination.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/19/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pagination {
    var current_page:Int
    var limit:Int
    var total_count:Int
    var total_pages:Int
    
    init(_ dataJSON:JSON) {
        current_page = dataJSON["current_page"].intValue
        limit = dataJSON["limit"].intValue
        total_count = dataJSON["total_count"].intValue
        total_pages = dataJSON["total_pages"].intValue
    }
}
