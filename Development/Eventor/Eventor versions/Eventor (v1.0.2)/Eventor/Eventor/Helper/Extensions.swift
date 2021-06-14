//
//  Extension.swift
//  Eventor
//
//  Created by Saleh on 05/06/1440 AH.
//  Copyright © 1440 Eventor. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageURLStringUsingCashe(StringURL: String) {
        
        //stop the image from flashing before dowmloading
        self.image = nil
        
        //check image cache
        if let cachedImage = imageCache.object(forKey: StringURL as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise start a new download
        let url = NSURL(string: StringURL)
        let request = NSURLRequest(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
                return
            }
            
            
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: StringURL as AnyObject)
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}
