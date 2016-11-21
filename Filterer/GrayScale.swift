//
//  RedFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class GrayScale : Filter {
    //var intensity : Float = 0
    
    
    
    //public init(intensity : Float){
       // self.intensity = intensity
        
    //}
    
    public override func apply() {
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let weightedAvgRed = Double(pixel.red) * 0.21
                let weightedAvgGreen = Double(pixel.green) * 0.72
                let weightedAvgBlue = Double(pixel.blue) * 0.07
                
                let avgValue = weightedAvgRed + weightedAvgGreen + weightedAvgBlue / 3
                
                pixel.red = UInt8(max(0,min(255,avgValue)))
                pixel.green = UInt8(max(0,min(255,avgValue)))
                pixel.blue = UInt8(max(0,min(255,avgValue)))
                rgbaImage.pixels[index] = pixel
                
            }
        }
        
    }
    
}
