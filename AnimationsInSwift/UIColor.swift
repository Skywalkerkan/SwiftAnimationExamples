//
//  UIColor.swift
//  AnimationsInSwift
//
//  Created by Erkan on 4.03.2023.
//

import Foundation


import UIKit


extension UIColor{
    
    static func colorRGB(r: Int, g: Int, b: Int) -> UIColor{
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
    
    
    static let pulsingFillColor = UIColor.colorRGB(r: 179, g: 230, b: 255)
    static let backgroundColor = UIColor.colorRGB(r: 247, g: 255, b: 230)
    static let traceStrokeColor = UIColor.colorRGB(r: 102, g: 204, b: 255)
    static let outlineStrokeColor = UIColor.colorRGB(r: 229, g: 51, b: 109)
    static let pulsingFillColorFinish = UIColor.colorRGB(r: 255, g: 180, b: 200)
    
}
