//
//  APINetworkManager.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation
import UIKit

struct APINetworkManager: APINetworkManagerProtocol {
    
    let router = Router<APIManager>()
    
    func searchFlickrImages(_ page: Int = 1,
                            searchText: String,
                            completion: @escaping (_ photos: Photos?, _ error: String?) -> Void) {
        
        router.request(.searchFlickrImages(page, searchText)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    
                    guard let responseData =  data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(SearchFlickrImagesResponse.self, from: responseData)
                        
                        if let stat = response.stat, stat == "ok" {
                            completion(response.photos, nil)
                        } else {
                            completion(nil, NetworkResponse.badRequest.rawValue)
                            
                        }
                        
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let networkFailureError):
                    
                    guard let responseData =  data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        print(jsonData)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                    completion(nil, networkFailureError)
                }
                
            }
            
        }
        
        
    }
    
    func downloadImage(_ url: URL, completion: @escaping (_ image: UIImage?, _ error: String?) -> Void) {
        
        router.request(.downloadImage(url)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    
                    guard let responseData = data, let image = UIImage(data: responseData) else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    completion(image, nil)
                    
                case .failure(let networkFailureError):
                    
                    guard let responseData =  data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        
                        print(jsonData)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                    completion(nil, networkFailureError)
                }
                
            }
            
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outDated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
