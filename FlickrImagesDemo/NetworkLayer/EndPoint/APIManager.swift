//
//  APIManager.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation


public enum APIManager {
    
    case searchFlickrImages(Int, String)
    case downloadImage(URL)
    
}


extension APIManager: EndPointType {
    
    var environmentBaseURL: String {
        
        switch NetworkManager.environment {
        
        case .dev           : return "https://api.flickr.com/services/rest/"
        case .qa            : return "https://api.flickr.com/services/rest/"
        case .staging       : return "https://api.flickr.com/services/rest/"
        case .production    : return "https://api.flickr.com/services/rest/"
        case .alpha         : return "https://api.flickr.com/services/rest/"
            
        }
        
    }
    
    var baseURL: URL {
        
        switch self {
        case .downloadImage(let url):
            return url
        default:
            guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured") }
            return url
        }
        
    }
    
    var path: String {
        
        switch self {
        case .searchFlickrImages: return ""
        case .downloadImage: return ""
            
        }
        
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        
        switch self {
        case .searchFlickrImages(let page, let searchText):
            
            let uRLParameters: [String: Any] = ["method": "flickr.photos.search",
                                 "api_key": NetworkManager.flickrApiKey,
                                 "format": "json",
                                 "nojsoncallback": 1,
                                 "safe_search":1,
                                 "text":searchText,
                                 "page": page]
            
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: uRLParameters, additionalHeaders: nil)
        
        case .downloadImage:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: nil)
            
        }
        
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
