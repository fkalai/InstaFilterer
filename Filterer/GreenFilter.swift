//
//  GreenFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class GreenFilter : Filter {
    var intensity : Float = 0
    
    
    
    public init(intensity : Float){
        self.intensity = intensity
        
    }
    
    public override func apply() {
        var totalGreen = 0
        let avgGreen :Float
        let count: Int
        
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage!.pixels[index]
                totalGreen += Int(pixel.green)
            }
        }
        count = rgbaImage!.width * rgbaImage!.height // total number of pixels in the image
        avgGreen = Float(totalGreen) / Float(count)
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let greenDelta : Float = Float(pixel.green) - avgGreen
                if (greenDelta > 0) {
                  pixel.green = UInt8(max(0, min(255, avgGreen + greenDelta * intensity)))
                rgbaImage.pixels[index] = pixel
                }
                
            }
        }
        
    }
    
}
