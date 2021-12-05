//
//  APINetworkManagerTests.swift
//  FlickrImagesDemoTests
//
//  Created by Mac-145-Pranay-Pawar on 05/12/21.
//

import Foundation


import XCTest
@testable import FlickrImagesDemo

class APINetworkManagerTests: XCTestCase {
    
    var testAPINetworkManager: TestAPINetworkManager!
    
    override func setUpWithError() throws {
     
        let searchFlickrImagesResponseData = loadStub(name: "FlickrImageSearchResponse", fileExtension: "json")
        
        let decoder = JSONDecoder()
        
        let searchFlickrImagesResponse = try decoder.decode(SearchFlickrImagesResponse.self, from: searchFlickrImagesResponseData)
        
        let sampleImage = loadImageAsset(name: "sample")
                
        testAPINetworkManager = TestAPINetworkManager(searchFlickrImagesResponse, downloadImageResponse: sampleImage)

    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testSearchFlickrImagesValidResponse() {
        
        let expectation = self.expectation(description: "Search Flickr Images Valid Response Expectation")
        
        let searchText = "kitten"
        let pageNumber = 1
        
        testAPINetworkManager.searchFlickrImages(pageNumber, searchText: searchText) { (response, errorString) in
            
            XCTAssertNil(errorString)
            
            guard let photosResponse = response else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(photosResponse)
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSearchFlickrImagesError() {
        
        let expectation = self.expectation(description: "Search Flickr Images Error Expectation")
        
        testAPINetworkManager.shouldReturnWithError = true
        
        let searchText = "kitten"
        let pageNumber = 1
        
        testAPINetworkManager.searchFlickrImages(pageNumber, searchText: searchText) { (response, errorString) in
            
            XCTAssertNotNil(errorString)

            XCTAssertNil(response)
            
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDownloadImageValidImage() {
        
        let expectation = self.expectation(description: "Download Valid Image Expectation")

        let url = URL(string: "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")!
                
        testAPINetworkManager.shouldReturnWithError = false
        
        testAPINetworkManager.downloadImage(url) { (image, errorString) in
            
            XCTAssertNil(errorString)
            
            guard let sampleImage = image else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(sampleImage)
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDownloadImageWithError() {
        
        let expectation = self.expectation(description: "Download Image Error Expectation")

        let url = URL(string: "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")!
        
        testAPINetworkManager.shouldReturnWithError = true
        
        testAPINetworkManager.downloadImage(url) { (image, errorString) in
            
            XCTAssertNotNil(errorString)

            XCTAssertNil(image)
            
            expectation.fulfill()
            
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
}
