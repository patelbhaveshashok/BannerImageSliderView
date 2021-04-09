//
//  BannerImageSliderCollectionViewCell.swift
//  BannerImageSlider
//
//  Created by Bhavesh Patel on 07/04/21.
//

import UIKit

class BannerImageSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: ShimmerImageView?
    var banner: SliderViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setBanner(_ thisBanner: SliderViewModel) {
        banner = thisBanner
        thisBanner.didSetImage = { [weak self] (image) in
            DispatchQueue.main.async {
                self?.setUpImageView()
            }
        }
        setUpImageView()
    }
    
    func setUpImageView() {
        if banner?.image == nil,
            banner?.isFetchingImage == true {
            imageView?.configureShimmerAndShow()
        } else if let thisImage = banner?.image,
            banner?.isFetchingImage == false {
            imageView?.stopShimmering()
            setImage(thisImage)
        } else {
            imageView?.stopShimmering()
            imageView?.image = nil
        }
    }
    
    func setImage(_ image: UIImage) {
        if banner?.showPlaceholderImage == true {
            imageView?.contentMode = .center
        } else {
            imageView?.contentMode = .scaleAspectFit
        }
        imageView?.image = image
    }
}
