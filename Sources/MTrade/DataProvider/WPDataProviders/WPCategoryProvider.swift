//
//  WPCategoryProvider.swift
//  
//
//  Created by Vsevolod Migdisov on 26.06.2022.
//

import Foundation

public class WPCategoryProvider: DataProvider, DataParser {
    
    public var url: URL
    
    public init(with url: String) {
        self.url = URL(string: url + "/wp-json/wc/v3/mtrade_categories?page=1")!
    }
    
    public func get(completion: @escaping ([Entity]?) -> Void) {
        return WPDataProvider().get(url: url, parser: self) { (entities: [Entity]?) -> Void in
            completion(entities)
        }
    }
    
    public func parse(_ data: Data) -> [Entity]? {
        var parsedData = [Entity]()
        do {
            let response = try JSONDecoder().decode([Response].self, from: data)
            for item in response {
                let category = DataManager.update(id: String(item.id)) { (object: Category) in
                    object.id = String(item.id)
                    object.name = item.name ?? ""
                    object.descr = item.description ?? ""
                    //object.parent = String(item.parent ?? 0)
                    object.display = displayMap[item.display ?? ""] ?? 0
                    object.position = item.menu_order ?? 0
                }
                guard let category = category else { continue }
                parsedData.append(.category(category))
            }
        } catch {
            print(error)
        }
        return parsedData
    }
    
    ///JSON Decoding structures
    private struct Response: Decodable {
        var id: Int16
        var name: String?
        var description: String?
        var parent: Int16?
        var display: String?
        var menu_order: Int16?
        var image: ImagesResponse?
    }
    
    private struct ImagesResponse: Decodable {
        var id: Int16
        var src: String
        var date_modified_gmt: String
        //var pictureContainer: PictureContainer { PictureContainer(id: "cat_\(String(id))", url: src, modified: date_modified_gmt) }
    }
    
    private let displayMap: [String: Int16] = [
        "products": 1,
        "subcategories": 2,
        "both": 0]
}
