//
//  BannerImageSliderCollectionView.swift
//  BannerImageSlider
//
//  Created by Bhavesh Patel on 07/04/21.
//

import UIKit

extension UICollectionView {
    func registerNib(for name: String, with id: String? = nil) {
        register(UINib(nibName: name, bundle: Bundle.main), forCellWithReuseIdentifier: (id == nil) ? name : id!)
    }
}

protocol BannerImageSliderCollectionViewDataSource {
    func getImageUrlStrings()->[String]
    func getImageHeight()->CGFloat
    func getImageWidth()->CGFloat
    func didSelectBannerAtIndex(banner: String)
    func setPageCurrentIndex(index: Int)
}

class BannerImageSliderCollectionView: UICollectionView {
    
    var componentDataSource: BannerImageSliderCollectionViewDataSource?
    var currentPageIndex = 0 {
        didSet {
            componentDataSource?.setPageCurrentIndex(index: currentPageIndex)
        }
    }
    let timerHandler = BannerImageViewTimerHandler()
    var banners = [SliderViewModel]()
    var isManulScrollIndexUpdated = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNib(for: String(describing: BannerImageSliderCollectionViewCell.self))
        backgroundColor = .white
        
        dataSource = self
        delegate = self
        
        if let thisArray = componentDataSource?.getImageUrlStrings() {
            thisArray.forEach { (imageUrl) in
                let viewModel = SliderViewModel(imageURL: imageUrl)
                banners.append(viewModel)
            }
        }
        
        timerHandler.timerComlpetion = { [weak self] (userInfo) in
            self?.timerHandler.pauseTimer()
            self?.nextPage()
        }
        reload()
    }
    
    func nextPage() {
        if currentPageIndex < (banners.count-1) {
            currentPageIndex += 1
            scrollToItem(at: IndexPath(item: currentPageIndex, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            currentPageIndex = 0
            scrollToItem(at: IndexPath(item: currentPageIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        timerHandler.startOrResumeTimer()
    }
    
    func reload() {
        collectionViewLayout.invalidateLayout()
        reloadData()
    }
}

extension BannerImageSliderCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerImageSliderCollectionViewCell.self), for: indexPath) as? BannerImageSliderCollectionViewCell
        if banners.indices.contains(indexPath.item) {
            let banner = banners[indexPath.item]
            cell?.setBanner(banner)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentPageIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = componentDataSource?.getImageHeight() ?? 200
        let width = componentDataSource?.getImageWidth() ?? bounds.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if banners.indices.contains(indexPath.item),
           let thisUrlString = banners[indexPath.item].imageURL {
            componentDataSource?.didSelectBannerAtIndex(banner: thisUrlString)
        }
    }
}
