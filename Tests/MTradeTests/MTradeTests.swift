import XCTest
@testable import MTrade

final class MTradeTests: XCTestCase {
    
    override func setUpWithError() throws {
        MTrade.setup(with: .wp(.wpURL))
    }

    override func tearDownWithError() throws {}
    
    func testExample() throws {
        let expectation = expectation(description: "")
        let dataProvider = Entity.category(nil).dataProvider!
        XCTAssertEqual(dataProvider.url.absoluteString, .wpURL + "/wp-json/wc/v3/mtrade_categories?page=1")
        dataProvider.get { (entities: [Entity]?) in
            XCTAssertEqual(entities?.count ?? 0, 35)
            guard let entities: [Entity] = entities else { print("Error getting categories"); return }
            for entity in entities {
                if case .category(let category) = entity {
                    print("name: \(category?.name ?? "")")
                }
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (error) in
            if error != nil {
                XCTFail(error?.localizedDescription ?? "Undefined network error")
            }
        }
    }
}
