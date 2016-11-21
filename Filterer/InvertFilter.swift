//
//  RedFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class InvertFilter : Filter {
    //var intensity : Float = 0
    
    
    
    //public init(intensity : Float){
    // self.intensity = intensity
    
    //}
    
    public override func apply() {
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let newRed = 255 - Int(pixel.red)
                let newGreen = 255 - Int(pixel.green)
                let newBlue = 255 - Int(pixel.blue)
                
                pixel.red = UInt8(max(0,min(255,newRed)))
                pixel.green = UInt8(max(0,min(255,newGreen)))
                pixel.blue = UInt8(max(0,min(255,newBlue)))
                rgbaImage.pixels[index] = pixel
                
            }
        }
        
    }
    
}
