//
//  WPDataProvider.swift
//  
//
//  Created by Vsevolod Migdisov on 26.06.2022.
//

import Foundation

/// Get data from remote storage.
class WPDataProvider {
    
    private var request: URLRequest!
    
    private var entities: [Entity]!
    
    /// Fetch and parse response data.
    /// - Parameter completion: Async closure executed when all data fetched and parsed.
    func get(url: URL, parser: DataParser, completion: @escaping ([Entity]) -> Void) {
        entities = [Entity]()
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        fetch(request, parser, completion)
    }
    
    /// Checks if all data is fetched from server and updates URLRequest with URL specified in `request` to fetch more data.
    /// - Parameter response: HTTP `response` from previous URL session.
    private func fetch(_ request: URLRequest, _ parser: DataParser, _ completion: @escaping ([Entity]) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("NetworkDataService error: \(error!.localizedDescription)")
                return
            }
            if let data = data, let response = response as? HTTPURLResponse {
                print(String(data: data, encoding: .utf8) ?? "")
                DispatchQueue.main.async { [self] in
                    if let parsedData: [Entity] = parser.parse(data) {
                        entities.append(contentsOf: parsedData)
                    } else {
                        print("Can't parse data")
                    }
                    if getNextURL(response: response) {
                        fetch(request, parser, completion)
                    } else {
                        completion(entities)
                    }
                }
            } else {
                print("Unknown NetworkDataService error")
            }
        }.resume()
    }
    
    /// Checks if all data is fetched from server and updates URLRequest with URL specified in `response` to fetch more data.
    /// - Parameter response: HTTP `response` from previous URL session.
    /// - Returns: *true* if URL to fetch more data is specified in `response`.
    private func getNextURL(response: HTTPURLResponse) -> Bool {
        let responseLinkItems = response.value(forHTTPHeaderField: "Link")?.split(separator: ",")
            .map({ $0.split(separator: ";") }) ?? []
        if let nextURLString = responseLinkItems
            .filter({ $0.count > 1 })
            .filter({ String($0[1]) == " rel=\"next\"" }).first?[0]
            .trimmingCharacters(in: CharacterSet(charactersIn: " <>")), let nextURL = URL(string: nextURLString) {
            request.url = nextURL
            return true
        } else {
            return false
        }
    }
}
