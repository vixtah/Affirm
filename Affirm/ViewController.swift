//
//  ViewController.swift
//  Affirm
//
//  Created by Victor on 11/2/18.
//  Copyright © 2018 Vixtah. All rights reserved.
//

import UIKit

//TODO: Empty state
//TODO: Offline empty state
//TODO: Force unwraps
//TODO: iPhoneX support

class GalleryViewController: UIViewController {
    var photos = [PhotoDecodable]()
    let interactor: GalleryInteractor
    let collectionView: UICollectionView
    var curSearch = ""
    var page = 0
    
    static let ResuseID = "GalleryCellReuseId"
    
    init(interactor: GalleryInteractor) {
        self.interactor = interactor
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 110)
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GalleryCell.self,
                                     forCellWithReuseIdentifier: GalleryViewController.ResuseID)
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .white
        
        let searchBar = UISearchBar.init()
        searchBar.delegate = self
        
        self.view = GalleryView.init(collectionView: collectionView,
                                     searchBar: searchBar)

    }
    
    required init?(coder aDecoder: NSCoder) {
        //TODO: handle this better
        fatalError()
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            interactor.getImage(urlString: photos[indexPath.row].url_s ?? "",
                                cb: {_ in })
            if indexPath.row == photos.count - 40 {
                page += 1
                search(text: curSearch)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewController.ResuseID,
                                                      for: indexPath) as! GalleryCell
        let urlString = photos[indexPath.row].url_s
        cell.urlString = urlString
        
        interactor.getImage(urlString: photos[indexPath.row].url_s ?? "",
                            cb: { (image: UIImage) in
            DispatchQueue.main.async {
                if cell.urlString == urlString {
                    cell.imageView.image = image
                }
            }
        })
        
        return cell
    }
    
}

extension GalleryViewController: UISearchBarDelegate {
    
    func search(text: String) {
        interactor.search(text: text,
                          page: page,
                          cb: { (photos: [PhotoDecodable]) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.photos += photos
                var indexPaths = [IndexPath]()
                let count = strongSelf.photos.count
                for i in count-photos.count..<count {
                    indexPaths.append(IndexPath.init(row: i, section: 0))
                }
                strongSelf.collectionView.insertItems(at: indexPaths)
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        curSearch = text
        
        photos = []
        //TODO: change this to update and delete indexPaths
        collectionView.reloadData()
        page = 0
        searchBar.resignFirstResponder()
        search(text: text)
    }
}

