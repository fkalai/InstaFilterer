//
//  BlueFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class BlueFilter : Filter {
    var intensity : Float = 0
    
    
    
    public init(intensity : Float){
        self.intensity = intensity
        
    }
    
    public override func apply() {
        var totalBlue = 0
        let avgBlue : Float
        let count: Int
        
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage!.pixels[index]
                totalBlue += Int(pixel.blue)
            }
        }
        count = rgbaImage!.width * rgbaImage!.height // total number of pixels in the image
        avgBlue = Float(totalBlue) / Float(count)
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]

                let blueDelta : Float = Float(pixel.blue) - avgBlue
                if (blueDelta > 0) {
                    pixel.blue = UInt8(max(0, min(255, avgBlue + blueDelta * intensity)))
                    rgbaImage.pixels[index] = pixel
                }
            }
        }
        
    }
    
}
