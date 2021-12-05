//
//  FlickrImagesViewController.swift
//  FlickrImagesDemo
//
//  Created by Mac-145-Pranay-Pawar on 04/12/21.
//

import UIKit

class FlickrImagesViewController: UIViewController {
    
    @IBOutlet weak var flickrImagesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: FilckrImagesListViewModel = FilckrImagesListViewModel(aPINetworkManager: APINetworkManager())
    var data: [Photo] = [Photo]()
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 3
    var currentPage: Int = 1
    let reuseIdentifier = "FlickrImageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        flickrImagesCollectionView.contentInsetAdjustmentBehavior = .always
        self.title = "Flickr"
    }
    
    func enterBusyUI() {
        DispatchQueue.main.async {
            self.searchBar.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func exitBusyUI() {
        DispatchQueue.main.async {
            self.searchBar.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }
}

extension FlickrImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? FlickrImageCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = nil
        
        if let flickrImageObj = viewModel.flickrImage(at: indexPath.row) {
            
            let identifier = flickrImageObj.id
            cell.identifier = identifier
            
            if let imageURL = flickrImageObj.flickrImageURL {
                
                viewModel.downloadImage(imageURL) { (image) in
                    
                    if cell.identifier == identifier {
                        DispatchQueue.main.async {
                            if let image = image {
                                cell.imageView.image = image
                            } else {
                                cell.imageView.image = UIImage(named: "notfound")
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if viewModel.currentPage < viewModel.maxPage && indexPath.row == viewModel.currentCount - 1 && !viewModel.isContentLoading {
            viewModel.getImagesInNextPage()
        }
        
        
    }
}

extension FlickrImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

/*extension FlickrImagesViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let position = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        if position > (height - scrollView.frame.size.height) {
            
            if let maxTotal = viewModel.model?.total, let currentTotal = viewModel.model?.filckrImages.count, maxTotal > currentTotal, !viewModel.isContentLoading {
                viewModel.getImagesInNextPage()
            }
            
        }
    }
    
}*/

extension FlickrImagesViewController: FilckrImagesListViewModelDelegate {
    
    func modelUpdated() {
        
        DispatchQueue.main.async {
            
            self.exitBusyUI()
            
            if self.viewModel.currentPage == 1 {
                self.flickrImagesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: false)
            }
            
            self.flickrImagesCollectionView.reloadData()
            
        }
        
    }
    
    func noDataFound() {
        
        exitBusyUI()
        
    }
    
}

extension FlickrImagesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        if let searchedText = searchBar.text{
            enterBusyUI()
            viewModel.searchFlickrImages(searchedText)
        }
    }
    
}
