//
//  Filter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class Filter : NSObject{
    var image:UIImage!
    var rgbaImage:RGBAImage!
    
    public func setBaseImage(image:UIImage!){
        self.image = image
        self.rgbaImage = RGBAImage(image: image)
    }
    
    // apply to a filter
    public func apply() {
    }
    
    public func toUIImage() -> UIImage{
        return self.rgbaImage.toUIImage()!
    }
}
