//
//  NetworkManager.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation

enum NetworkResponse: String {
    
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad Request"
    case outDated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    
}

enum NetworkResult {
    case success
    case failure(String)
}

struct NetworkManager {
    
    static let environment : NetworkEnvironment = .production
    static let flickrApiKey = "2932ade8b209152a7cbb49b631c4f9b6"

}
