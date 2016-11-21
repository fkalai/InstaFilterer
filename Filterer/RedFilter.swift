//
//  RedFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class RedFilter : Filter {
    var intensity : Float = 0
    

    
    public init(intensity : Float){
        self.intensity = intensity

    }
    
    public override func apply() {
        var totalRed = 0
        let avgRed : Float
        let count: Int
        
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage!.pixels[index]
                totalRed += Int(pixel.red)
            }
        }
        count = rgbaImage!.width * rgbaImage!.height // total number of pixels in the image
        avgRed = Float(totalRed) / Float(count)

        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let redDelta : Float = Float(pixel.red) - avgRed
                if (redDelta > 0) {
                    pixel.red = UInt8(max(0, min(255, avgRed + redDelta * intensity)))
                    rgbaImage.pixels[index] = pixel
                }
                
            }
        }
        
    }
    
}
