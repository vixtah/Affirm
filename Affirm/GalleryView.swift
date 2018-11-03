//
//  GalleryView.swift
//  Affirm
//
//  Created by Victor on 11/3/18.
//  Copyright © 2018 Vixtah. All rights reserved.
//

import UIKit

class GalleryView: UIView {
    let collectionView: UICollectionView
    let searchBar: UISearchBar
    
    init(collectionView: UICollectionView,
         searchBar: UISearchBar) {
        self.collectionView = collectionView
        self.searchBar = searchBar
        
        super.init(frame: .zero)
        
        self.addSubview(collectionView)
        self.addSubview(searchBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = 88.0
        searchBar.frame = CGRect.init(x: 0, y: height, width: bounds.size.width, height: 44)
        collectionView.frame = CGRect.init(x: 0, y: height+44, width: bounds.size.width, height: bounds.size.height - height-44)
    }
}

class GalleryCell: UICollectionViewCell {
    let imageView = UIImageView()
    var urlString: String?
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //TODO: handle this better
        fatalError()
    }
    
    override func layoutSubviews() {
        imageView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        urlString = nil
        imageView.image = nil
    }
}
