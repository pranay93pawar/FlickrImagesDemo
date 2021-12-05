//
//  NetworkRouter.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint : EndPointType
    
    func request(_ route: EndPoint, completion:@escaping NetworkRouterCompletion)
    
    func cancel()
}
