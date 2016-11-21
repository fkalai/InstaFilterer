//
//  RedFilter.swift
//  Filterer
//
//  Created by fenomeno69 on 13/11/2016.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class Brightness : Filter {
    var intensity : Float = 0
    
    
    
    public init(intensity : Float){
     self.intensity = intensity
    
    }
    
    public override func apply() {
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let red = Float(pixel.red) * intensity
                let green = Float(pixel.green) * intensity
                let blue = Float(pixel.blue) * intensity
                
                pixel.red = UInt8(max(0,min(255,red)))
                pixel.green = UInt8(max(0,min(255,green)))
                pixel.blue = UInt8(max(0,min(255,blue)))
                rgbaImage.pixels[index] = pixel
                
            }
        }
        
    }
    
}
