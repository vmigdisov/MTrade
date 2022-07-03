//
//  Entity.swift
//  
//
//  Created by Vsevolod Migdisov on 26.06.2022.
//

import Foundation

public enum Entity {
    
    case category(Category?), product(Product?), picture(Picture?), review(Review?)
    
    public var dataProvider: DataProvider? {

        switch MTrade.resource {
        case .wp(let url):
            switch self {
            case .category: return WPCategoryProvider(with: url)
            default: return nil
            }
        case .none:
            MTrade.configurationError()
            return nil
        }
    }
}
