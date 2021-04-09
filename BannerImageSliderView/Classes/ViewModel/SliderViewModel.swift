//
//  SliderViewModel.swift
//  BannerImageSlider
//
//  Created by Bhavesh Patel on 09/04/21.
//

import UIKit

extension UIImage {
    class func loadImageWithURL(_ url: URL, withCompletion completion: ((UIImage?)->Void)?) {
        
        URLSession.shared.downloadTask(with: url, completionHandler: { url, response, error in
            var image: UIImage? = nil
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let thisImage = UIImage(data: data) {
                image = thisImage
            }
            DispatchQueue.main.async {
                completion?(image)
            }
        }).resume()
    }
}

class SliderViewModel {
    var image: UIImage?
    var didSetImage: ((UIImage?)->Void)?
    var imageURL: String?
    
    var isFetchingImage: Bool = false
    var showPlaceholderImage = false
    
    init(imageURL: String) {
        self.imageURL = imageURL
        
        if !imageURL.isEmpty,
            let thisURL = URL(string: imageURL) {
            isFetchingImage = true
            UIImage.loadImageWithURL(thisURL) { [weak self] (image) in
                self?.image = image
                self?.isFetchingImage = false
                self?.didSetImage?(image)
            }
        } else {
            showPlaceholderImage = true
            isFetchingImage = false
        }
    }
}
