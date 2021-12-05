//
//  FilckrImagesListViewModelTests.swift
//  FlickrImagesDemoTests
//
//  Created by Mac-145-Pranay-Pawar on 05/12/21.
//

import XCTest
@testable import FlickrImagesDemo

class FilckrImagesListViewModelTests: XCTestCase {
    
    var viewModel: FilckrImagesListViewModel!
    var testAPINetworkManager: TestAPINetworkManager!
    
    override func setUpWithError() throws {
        
        let searchFlickrImagesResponseData = loadStub(name: "FlickrImageSearchResponse", fileExtension: "json")
        
        let decoder = JSONDecoder()
        
        let searchFlickrImagesResponse = try decoder.decode(SearchFlickrImagesResponse.self, from: searchFlickrImagesResponseData)
        
        let ssampleImage = loadImageAsset(name: "sample")
        
        testAPINetworkManager = TestAPINetworkManager(searchFlickrImagesResponse, downloadImageResponse: ssampleImage)
        
        viewModel = FilckrImagesListViewModel(aPINetworkManager: testAPINetworkManager)
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testTotalCount() {
        
        let expectation = self.expectation(description: "Model TotalCount Expectation")
        
        let searchText = "kitten"
        
        viewModel.searchFlickrImages(searchText)
        
        XCTAssertEqual(viewModel.totalCount, 132037)
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testCurrentCount() {
        
        let expectation = self.expectation(description: "Model CurrentCount Expectation")
        
        let searchText = "kitten"
        
        viewModel.searchFlickrImages(searchText)
        
        XCTAssertEqual(viewModel.currentCount, 100)
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testCurrentPage() {
        
        let expectation = self.expectation(description: "Model CurrentPage Expectation")
        
        let searchText = "kitten"
        
        viewModel.searchFlickrImages(searchText)
        
        XCTAssertEqual(viewModel.currentPage, 1)
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testMaxPage() {
        
        let expectation = self.expectation(description: "Model MaxPage Expectation")
        
        let searchText = "kitten"
        
        viewModel.searchFlickrImages(searchText)
        
        XCTAssertEqual(viewModel.maxPage, 1321)
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testFickrImageAtIndex() {
        
        let expectation = self.expectation(description: "Model FickrImageAtIndex Expectation")
        
        let searchText = "kitten"
        
        viewModel.searchFlickrImages(searchText)
        
        let index = 0
        
        if let photo = viewModel.flickrImage(at: index) {
            
            XCTAssertNotNil(photo)
            
        } else {
            XCTFail()
        }
        
        expectation.fulfill()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func testDownloadImage() {
        
        let expectation = self.expectation(description: "Download Image Expectation")
        
        let url = URL(string: "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")!
        
        viewModel.downloadImage(url) { (image) in
            
            if let image = image {
                XCTAssertNotNil(image)
                expectation.fulfill()
            } else {
                XCTFail()
            }
            
            
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
}
