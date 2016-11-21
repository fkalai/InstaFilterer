//
//  RedFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class SepiaFilter : Filter {
    //var intensity : Float = 0
    
    
    
    //public init(intensity : Float){
    // self.intensity = intensity
    
    //}
    
    public override func apply() {
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let red = Double(pixel.red)
                let green = Double(pixel.green)
                let blue = Double(pixel.blue)
                let redAlgo = (red * 0.393) + (green * 0.769) + (blue * 0.189)
                let greenAlgo = (red * 0.349) + (green * 0.686) + (blue * 0.168)
                let blueAlgo = (red * 0.272) + (green * 0.534) + (blue * 0.131)
                
                pixel.red = UInt8(max(0,min(255,redAlgo)))
                pixel.green = UInt8(max(0,min(255,greenAlgo)))
                pixel.blue = UInt8(max(0,min(255,blueAlgo)))
                rgbaImage.pixels[index] = pixel
                
            }
        }
        
    }
    
}
