//
//  DataProviderProtocols.swift
//  
//
//  Created by Vsevolod Migdisov on 26.06.2022.
//

import Foundation

public protocol CategoryDataProvider {
    var url: URL { get }
    func get(completion: @escaping (_ data: [Category]?) -> Void)
}

public protocol DataParser {
    func parse(_ data: Data) -> [Entity]?
}
