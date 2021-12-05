//
//  APINetworkManagerProtocol.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation
import UIKit

protocol APINetworkManagerProtocol {
    
    func searchFlickrImages(_ page: Int,
                            searchText: String,
                            completion: @escaping (_ photos: Photos?, _ error: String?) -> Void)
    
    
    func downloadImage(_ url: URL, completion: @escaping (_ image: UIImage?, _ error: String?) -> Void)
    
}
