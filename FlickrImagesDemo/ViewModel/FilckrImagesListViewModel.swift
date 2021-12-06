//
//  FilckrImagesListViewModel.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import Foundation
import UIKit

class FilckrImagesListViewModel {
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    private var model: FilckrImagesList? {
        
        didSet {
            delegate?.modelUpdated()
        }
        
    }

    let aPINetworkManager: APINetworkManagerProtocol
    weak var delegate: FilckrImagesListViewModelDelegate?
    var isContentLoading: Bool = false
    
    var totalCount: Int {
        return model?.total ?? 0
    }
    
    var currentCount: Int {
        return model?.filckrImages.count ?? 0
    }
    
    var currentPage: Int {
        return model?.currentPage ?? 0
    }
    
    var maxPage: Int {
        return model?.maxPage ?? 0
    }
    
    func flickrImage(at index: Int) -> Photo? {
        
        if index < currentCount {
            return model?.filckrImages[index]
        }
        return nil
    }
    
    init(aPINetworkManager: APINetworkManagerProtocol) {
        self.aPINetworkManager = aPINetworkManager
    }
    
    func clearImageCache() {
        cachedImages.removeAllObjects()
    }
    
    func searchFlickrImages(_ searchText: String) {
        
        self.clearImageCache()
        
        let currentPage = 1
        
        aPINetworkManager.searchFlickrImages(currentPage, searchText: searchText) { (photosResponse, errorString) in
            
            if let photos = photosResponse, let photoList = photos.photo, let currentPage = photos.page, let maxPage = photos.pages, let total = photos.total {
                
                if self.model == nil {
                    self.model = FilckrImagesList(filckrImages: photoList, searchText: searchText, currentPage: currentPage, maxPage: maxPage, total: total)
                } else {
                    self.model?.setFilckrImages(photoList)
                    self.model?.setSearchText(searchText)
                    self.model?.setCurrentPage(currentPage)
                    self.model?.setMaxPage(maxPage)
                    self.model?.setTotal(total)
                    self.delegate?.modelUpdated()
                }
            } else {
                self.delegate?.noDataFound()
            }
            
        }
        
    }
    
    func getImagesInNextPage() {
        
        let nextPage = (model?.currentPage ?? 0) + 1
        
        if let maxPage = model?.maxPage, maxPage < nextPage {
            
            delegate?.noDataFound()
            return
        }
        
        let searchText = model?.searchText ?? "kitten"
        
        isContentLoading = true
        
        aPINetworkManager.searchFlickrImages(nextPage, searchText: searchText) { (photosResponse, errorString) in
            
            if let photos = photosResponse, let photoList = photos.photo, let currentPage = photos.page, let maxPage = photos.pages {
                
                if self.model != nil {
                    
                    self.model?.appendFilckrImages(photoList)
                    self.model?.setCurrentPage(currentPage)
                    self.model?.setMaxPage(maxPage)
                    self.delegate?.modelUpdated()
                    self.isContentLoading = false
                }
            } else {
                self.delegate?.noDataFound()
            }
            
        }
        
    }
    
    func downloadImage(_ imageURL: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let cachedImage = cachedImages.object(forKey: imageURL as NSURL) {
            completion(cachedImage)
        } else {
            
            aPINetworkManager.downloadImage(imageURL) { (image, error) in
                
                if error != nil {
                    completion(nil)
                } else {
                    
                    if let image = image {
                        self.cachedImages.setObject(image, forKey: imageURL as NSURL)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
                
            }
            
        }
        
    }
    
}

protocol FilckrImagesListViewModelDelegate: NSObject {
    
    func modelUpdated()
    
    func noDataFound()
}
