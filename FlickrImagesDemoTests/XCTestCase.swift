//
//  XCTestCase.swift
//  FlickrImagesDemoTests
//
//  Created by Mac-145-Pranay-Pawar on 05/12/21.
//

import XCTest

extension XCTestCase {
    
    func loadStub(name: String, fileExtension: String) -> Data {
        
        let bundle = Bundle(for: type(of: self))
        
        let url = bundle.url(forResource: name, withExtension: fileExtension)
        
        return try! Data(contentsOf: url!)
    }
    
    func loadImageAsset(name: String) -> UIImage {
     
        let bundle = Bundle(for: type(of: self))

        return UIImage(named: name, in: bundle, compatibleWith: nil)!
    }
    
}
