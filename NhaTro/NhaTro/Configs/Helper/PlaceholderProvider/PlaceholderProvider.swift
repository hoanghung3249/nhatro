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
        commonStyle.actionBackgroundColor = .black
        commonStyle.actionTitleColor = .white
        commonStyle.titleColor = .black
        commonStyle.isAnimated = false
        
        var loadingStyle = commonStyle
        loadingStyle.actionBackgroundColor = .clear
        loadingStyle.actionTitleColor = .gray
        
        var loadingData: PlaceholderData = .loading
        loadingData.image = #imageLiteral(resourceName: "internetConnection")
        let loading = Placeholder(data: loadingData, style: loadingStyle, key: .loadingKey)
        
        var errorData: PlaceholderData = .error
        errorData.image = #imageLiteral(resourceName: "internetConnection")
        let error = Placeholder(data: errorData, style: commonStyle, key: .errorKey)
        
        var noResultsData: PlaceholderData = .noResults
        noResultsData.image = #imageLiteral(resourceName: "internetConnection")
        let noResults = Placeholder(data: noResultsData, style: commonStyle, key: .noResultsKey)
        
        var noConnectionData: PlaceholderData = .noConnection
        noConnectionData.image = #imageLiteral(resourceName: "internetConnection")
        let noConnection = Placeholder(data: noConnectionData, style: commonStyle, key: .noConnectionKey)
        
        let placeholdersProvider = PlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        
        placeholdersProvider.add(placeholders: PlaceholdersProvider.nhatroNoInternet)
        placeholdersProvider.add(placeholders: PlaceholdersProvider.nhatroNoResult)
        placeholdersProvider.add(placeholders: PlaceholdersProvider.nhatroError)
        
        return placeholdersProvider
    }
    
    private static var nhatroNoInternet: Placeholder {
        var nhatroStyle = PlaceholderStyle()
        nhatroStyle.backgroundColor = .white
        nhatroStyle.actionBackgroundColor = Color.mainColor()
        nhatroStyle.actionTitleColor = .white
        nhatroStyle.titleColor = .black
        nhatroStyle.isAnimated = true
        
        var nhatroData = PlaceholderData()
        nhatroData.title = NSLocalizedString("Whooops", comment: "")
        
        nhatroData.subtitle = NSLocalizedString("Đã xảy ra lỗi,\nKiểm tra lại kết nối!", comment: "")
        nhatroData.image = #imageLiteral(resourceName: "internetConnection")
        nhatroData.action = NSLocalizedString("Thử lại!", comment: "")
        
        let placeholder = Placeholder(data: nhatroData, style: nhatroStyle, key: PlaceholderKey.custom(key: "nhatroNoInternet"))
        
        return placeholder
    }
    
    private static var nhatroNoResult: Placeholder {
        var nhatroStyle = PlaceholderStyle()
        nhatroStyle.backgroundColor = .white
        nhatroStyle.actionBackgroundColor = Color.mainColor()
        nhatroStyle.actionTitleColor = .black
        nhatroStyle.titleColor = .black
        nhatroStyle.isAnimated = false
        
        var nhatroData = PlaceholderData()
        nhatroData.title = NSLocalizedString("Không có kết quả!", comment: "")
        nhatroData.subtitle = NSLocalizedString("Không tìm thấy nhà trọ nào!", comment: "")
        nhatroData.image = #imageLiteral(resourceName: "internetConnection")
        nhatroData.action = NSLocalizedString("Thử lại!", comment: "")
        
        let placeholder = Placeholder(data: nhatroData, style: nhatroStyle, key: PlaceholderKey.custom(key: "nhatroNoResult"))
        
        return placeholder
    }
    
    private static var nhatroError: Placeholder {
        var nhatroStyle = PlaceholderStyle()
        nhatroStyle.backgroundColor = .white
        nhatroStyle.actionBackgroundColor = Color.mainColor()
        nhatroStyle.actionTitleColor = .black
        nhatroStyle.titleColor = .black
        nhatroStyle.isAnimated = false
        
        var nhatroData = PlaceholderData()
        nhatroData.title = NSLocalizedString("Whooops", comment: "")
        nhatroData.subtitle = NSLocalizedString("Đã xảy ra lỗi", comment: "")
        nhatroData.image = #imageLiteral(resourceName: "internetConnection")
        nhatroData.action = NSLocalizedString("Thử lại!", comment: "")
        
        let placeholder = Placeholder(data: nhatroData, style: nhatroStyle, key: PlaceholderKey.custom(key: "nhatroError"))
        
        return placeholder
    }
    
}
