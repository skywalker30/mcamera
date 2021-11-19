//
//  UIImage.swift
//  mcamera
//
//  Created by Roman Sukner on 18/11/2021.
//

import Foundation
import UIKit

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case lower  = 0.1
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    enum MAXSize: Int {
        case k50   = 50000
        case k100  = 100000
        case k150  = 150000
        case k200  = 200000
    }
        
    func imageSize() -> Int? {
        return jpegData(compressionQuality: JPEGQuality.highest.rawValue)?.count
    }
    
    
    func max_compressImage(toMaxLength maxLength: MAXSize, maxWidth: Int) -> Data? {
  
        assert(maxWidth > 0, "bad width")
        
        let newSize = self.max_scale(withLength: CGFloat(maxWidth))
        let newImage = self.max_resize(withNewSize: newSize)
        
        var compress: CGFloat = 0.9
        
        var data = newImage?.jpegData(compressionQuality: compress)
        
        while (data?.count ?? 0) > maxLength.rawValue && compress > 0.01 {
            compress -= 0.02
            
            data = newImage?.jpegData(compressionQuality: compress)
        }
        return data
        
    }
    
    func max_resize( withNewSize newSize: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
       
    
    func max_scale(withLength imageLength: CGFloat) -> CGSize {
        
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        let width = self.size.width
        let height = self.size.height
        
        
        if width > imageLength || height > imageLength {
            if width > height {
                newWidth = imageLength
                newHeight = newWidth * height / width
            } else if height > width {
                newHeight = imageLength
                newWidth = newHeight * width / height
            } else {
                newWidth = imageLength
                newHeight = imageLength
            }
        }
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
        
}



