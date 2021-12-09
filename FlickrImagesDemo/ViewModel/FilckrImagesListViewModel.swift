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
        cachedImages.totalCostLimit = 20 * 1024 * 1024
    }
    
    func clearImageCache() {
        
        //cachedImages.removeAllObjects()
    }
    
    func searchFlickrImages(_ searchText: String) {
        
        self.clearImageCache()
        
        let currentPage = 1
        
        aPINetworkManager.searchFlickrImages(currentPage, searchText: searchText) { [weak self] (photosResponse, errorString) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let photos = photosResponse, let photoList = photos.photo, let currentPage = photos.page, let maxPage = photos.pages, let total = photos.total {
                
                if var model = strongSelf.model {
                    
                    model.setFilckrImages(photoList)
                    model.setSearchText(searchText)
                    model.setCurrentPage(currentPage)
                    model.setMaxPage(maxPage)
                    model.setTotal(total)
                    strongSelf.delegate?.modelUpdated()
                    
                } else {
                    strongSelf.model = FilckrImagesList(filckrImages: photoList, searchText: searchText, currentPage: currentPage, maxPage: maxPage, total: total)
                    
                    strongSelf.delegate?.modelUpdated()

                }
            } else {
                strongSelf.delegate?.noDataFound()
            }
            
        }
        
    }
    
    func getImagesInNextPage() {
        
        guard let strongModel = model else {
            self.delegate?.noDataFound()
            return
        }
        
        let nextPage = strongModel.currentPage + 1
        
        if strongModel.maxPage < nextPage {
            
            delegate?.noDataFound()
            return
        }
        
        let searchText = strongModel.searchText
        
        isContentLoading = true
        
        aPINetworkManager.searchFlickrImages(nextPage, searchText: searchText) { [weak self] (photosResponse, errorString) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let photos = photosResponse, let photoList = photos.photo, let currentPage = photos.page, let maxPage = photos.pages else {
                strongSelf.delegate?.noDataFound()
                return
            }
            
            guard var model = strongSelf.model else {
                strongSelf.delegate?.noDataFound()
                return
            }
            
            model.appendFilckrImages(photoList)
            model.setCurrentPage(currentPage)
            model.setMaxPage(maxPage)
            strongSelf.delegate?.modelUpdated()
            strongSelf.isContentLoading = false
            
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
                        
                        if let data = image.pngData() {
                            
                            self.cachedImages.setObject(image, forKey: imageURL as NSURL, cost: data.count)

                        } else {
                            self.cachedImages.setObject(image, forKey: imageURL as NSURL)

                        }
                        
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
