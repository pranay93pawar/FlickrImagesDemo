//
//  FilckrImagesList.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation

struct FilckrImagesList {
    
    private(set) var filckrImages: [Photo]
    private(set) var searchText: String
    private(set) var currentPage: Int = 1
    private(set) var maxPage: Int
    private(set) var total: Int
    
    mutating func setFilckrImages(_ filckrImages: [Photo]) {
        self.filckrImages = filckrImages
    }
    
    mutating func appendFilckrImages(_ filckrImages: [Photo]) {
        self.filckrImages.append(contentsOf: filckrImages)
    }
    
    mutating func setSearchText(_ text: String) {
        self.searchText = text
    }
    
    mutating func setCurrentPage(_ page: Int) {
        self.currentPage = page
    }
    
    mutating func setMaxPage(_ maxPage: Int) {
        self.maxPage = maxPage
    }
    
    mutating func setTotal(_ totalCount: Int) {
        self.total = totalCount
    }
}
