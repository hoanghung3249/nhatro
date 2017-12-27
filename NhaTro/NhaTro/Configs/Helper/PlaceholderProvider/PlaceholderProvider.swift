//
//  PlaceholderProvider.swift
//  NhaTro
//
//  Created by HOANGHUNG on 12/22/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import HGPlaceholders

extension PlaceholdersProvider {
    
    static var nhatroProvider: PlaceholdersProvider {
        var commonStyle = PlaceholderStyle()
        commonStyle.backgroundColor = .white
        commonStyle.actionBackgroundColor = Color.mainColor()
        commonStyle.actionTitleColor = .white
        commonStyle.titleColor = .black
        commonStyle.isAnimated = false
        
        var loadingStyle = commonStyle
        loadingStyle.actionBackgroundColor = .clear
        loadingStyle.actionTitleColor = .gray
        
        let loadingData: PlaceholderData = .nhatroLoading
        let loading = Placeholder(data: loadingData, style: loadingStyle, key: .loadingKey)
        
        var errorData: PlaceholderData = .nhatroError
        errorData.image = #imageLiteral(resourceName: "error")
        let error = Placeholder(data: errorData, style: commonStyle, key: .errorKey)
        
        var noResultsData: PlaceholderData = .nhatroNoResults
        noResultsData.image = #imageLiteral(resourceName: "notFound")
        let noResults = Placeholder(data: noResultsData, style: commonStyle, key: .noResultsKey)
        
        var noConnectionData: PlaceholderData = .nhatroNoInternet
        noConnectionData.image = #imageLiteral(resourceName: "no_internet")
        let noConnection = Placeholder(data: noConnectionData, style: commonStyle, key: .noConnectionKey)
        
        let placeholdersProvider = PlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        
        return placeholdersProvider
    }
}

extension PlaceholderData {
    
    public static var nhatroNoResults: PlaceholderData {
        var noResultsStyle = PlaceholderData()
        
        noResultsStyle.title = NSLocalizedString("Không có kết quả!", comment: "")
        noResultsStyle.subtitle = NSLocalizedString("Không tìm thấy nhà trọ nào!", comment: "")
        noResultsStyle.action = NSLocalizedString("Thử lại!", comment: "")
        
        return noResultsStyle
    }
    
    public static var nhatroLoading: PlaceholderData {
        let loadingStyle = PlaceholderData()
        return loadingStyle
    }
    
    public static var nhatroError: PlaceholderData {
        var errorStyle = PlaceholderData()
        errorStyle.title = NSLocalizedString("Whoops!", comment: "")
        errorStyle.subtitle = NSLocalizedString("Đã xảy ra lỗi\nXin hãy thử lại!", comment: "")
        errorStyle.action = NSLocalizedString("Thử lại!", comment: "")
        
        return errorStyle
    }
    
    public static var nhatroNoInternet: PlaceholderData {
        var noConnectionStyle = PlaceholderData()
        noConnectionStyle.title = NSLocalizedString("Whoops!", comment: "")
        noConnectionStyle.subtitle = NSLocalizedString("Đã xảy ra lỗi,\nKiểm tra lại kết nối!", comment: "")
        noConnectionStyle.action = NSLocalizedString("Thử lại!", comment: "")
        
        return noConnectionStyle
    }
}
