import XCTest
@testable import MTrade

final class MTradeTests: XCTestCase {
    
    override func setUpWithError() throws {
        MTrade.setup(with: .wp(.wpURL))
    }

    override func tearDownWithError() throws {}
    
    func testExample() throws {
        let expectation = expectation(description: "")
        let dataProvider = Entity.categoryDataProvider!
        XCTAssertEqual(dataProvider.url.absoluteString, .wpURL + "/wp-json/wc/v3/mtrade_categories?page=1")
        dataProvider.get {
            guard let categories = $0 else { return }
            XCTAssertEqual($0?.count ?? 0, 35)
            for category in categories {
                print("name: \(category.name ?? "")")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30.0) { (error) in
            if error != nil {
                XCTFail(error?.localizedDescription ?? "Undefined network error")
            }
        }
    }
}
