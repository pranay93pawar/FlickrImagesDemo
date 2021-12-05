//
//  NetworkError.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 05/10/21.
//

import Foundation

enum NetworkError: String, Error {
    
    case parametersNil
    case encodingFail
    case missingURL
    case urlError
    case networkUnavailable
}
