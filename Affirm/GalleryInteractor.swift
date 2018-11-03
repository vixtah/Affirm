//
//  GalleryInteractor.swift
//  Affirm
//
//  Created by Victor on 11/2/18.
//  Copyright © 2018 Vixtah. All rights reserved.
//

import UIKit

class PhotoDecodable: Decodable {
    let id: String
    let url_s: String?
}

class PhotosDecodable: Decodable {
    let photo: [PhotoDecodable]
}

class FlickrDecodable: Decodable {
    let photos: PhotosDecodable
}

class GalleryInteractor: NSObject {
    
    let urlSession: URLSession
    static let API_KEY = "675894853ae8ec6c242fa4c077bcf4a0"

    override init() {
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config)
        
        super.init()
    }
    
    func search(text: String,
                page: Int,
                cb: @escaping ([PhotoDecodable]) -> ()) {
        print(page)
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(GalleryInteractor.API_KEY)&text=\(text)&page=\(page)&extras=url_s&format=json&nojsoncallback=1"
        
        let url = URL.init(string: urlString)!
        
        urlSession.dataTask(with: url,
                            completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //TODO: handle errors, slow connection
            
            let decoder = JSONDecoder()
            do {
                let decodables = try decoder.decode(FlickrDecodable.self, from: data!)
                cb(decodables.photos.photo)
            } catch {
                print(error)
            }
        }).resume()
    }
    
    func getImage(urlString: String,
                  cb: @escaping (UIImage)->()) {
        if let url = URL.init(string: urlString) {
            urlSession.dataTask(with: url,
                                completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                                    guard error == nil else {
                                        //TODO: handle error
                                        return
                                    }
                                    if let data = data,
                                        let image = UIImage.init(data: data){
                                        cb(image)
                                    }
            }).resume()
        }
    }
}
