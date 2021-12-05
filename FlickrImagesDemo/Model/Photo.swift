//
//  Photo.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation

struct Photo: Codable {
    
    var id: String
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
    
    var flickrImageURL: URL? {
        
        get {
            
            if let farm = farm, let server = server, let secret = secret {
                return URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")
            }
            return nil
            
        }
        
    }
}
