//
//  TestAPINetworkManager.swift
//  FlickrImagesDemoTests
//
//  Created by Mac-145-Pranay-Pawar on 05/12/21.
//

import Foundation
import UIKit
@testable import FlickrImagesDemo

struct TestAPINetworkManager: APINetworkManagerProtocol {
    
    var shouldReturnWithError: Bool = false
    
    let searchFlickrImagesResponse: SearchFlickrImagesResponse
    let downloadImageResponse: UIImage
    
    init(_ searchFlickrImagesResponse: SearchFlickrImagesResponse, downloadImageResponse: UIImage) {
        self.searchFlickrImagesResponse = searchFlickrImagesResponse
        self.downloadImageResponse = downloadImageResponse
    }
    
    enum MockNWServiceError: Error {
        case searchFlickrImages
        case downloadImage
    }
    
    func searchFlickrImages(_ page: Int, searchText: String, completion: @escaping (Photos?, String?) -> Void) {
        
        if shouldReturnWithError {
            completion(nil, MockNWServiceError.searchFlickrImages.localizedDescription)
        } else {
            completion(searchFlickrImagesResponse.photos, nil)
        }
        
    }
    
    func downloadImage(_ url: URL, completion: @escaping (UIImage?, String?) -> Void) {
        
        if shouldReturnWithError {
            completion(nil, MockNWServiceError.downloadImage.localizedDescription)
        } else {
            completion(downloadImageResponse, nil)
        }
        
    }
}
