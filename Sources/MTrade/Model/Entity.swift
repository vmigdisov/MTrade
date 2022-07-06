//
//  Entity.swift
//  
//
//  Created by Vsevolod Migdisov on 26.06.2022.
//

import Foundation

public enum Entity {
    
    case category(Category), product(Product), picture(Picture), review(Review)
    
    public static var categoryDataProvider: CategoryDataProvider? {
        switch MTrade.resource {
        case .wp(let url): return WPCategoryProvider(with: url)
        case .none:
            MTrade.configurationError()
            return nil
        }
    }
}
