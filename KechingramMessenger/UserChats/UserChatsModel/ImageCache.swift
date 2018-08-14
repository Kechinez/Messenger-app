//
//  ImageCache.swift
//  KechingramMessenger
//
//  Created by Nikita Kechinov on 24.07.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit


extension UIImageView {
    func setupImageFromCache(using url: String?) {
        guard let url = url else { return }
        guard let image = imageCache.object(forKey: NSString(string: url)) as? UIImage else { return }
        self.image = image
    }
    
}

extension UIImage {
    
    convenience init?(using url: String?) {
        guard let url = url else { return nil }
        
        guard let image = imageCache.object(forKey: NSString(string: url)) as? Data else { return nil }
        
        self.init(data: image)
       
        
        }
    }

