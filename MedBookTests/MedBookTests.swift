//
//  MedBookTests.swift
//  MedBookTests
//
//  Created by Manikandan on 20/11/24.
//

import XCTest
@testable import MedBook
import NetworkManager
import Home

final class MedBookTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func fetchBooks() async throws{
        
    }

}

//class MockNetworkManager : NetworkManagerProtocol{
//    func getData(urlStr: String) async -> (Data?, String?) {
//        let mockData = """
//                {
//                    "docs": [
//                        {
//                            "title": "Mock Book",
//                            "ratings_average": 4.5,
//                            "ratings_count": 100,
//                            "author_name": ["Mock Author"],
//                            "cover_i": 12345
//                        }
//                    ]
//                }
//                """.data(using: .utf8)
//        return (mockData,nil)
//    }
//    
//    
//}
//
//let mockNM = MockNetworkManager()
//let viewModel = HomeScreenViewModel(networkManager: mockNM)
//viewModel.fetchBooks { books, error in
//    print(viewModel.medBooks)
//    XCTAssertEqual(books.count, 1, "Should fetch one book from the mock data.")
//    XCTAssertEqual(viewModel.medBooks.count, 1, "Should fetch one book from the mock data.")
//    XCTAssertEqual(viewModel.medBooks.first?.title ?? "", "Mock Book", "Should fetch one book from the mock data.")
//    XCTAssertNil(error, "There should be no error.")
//}
