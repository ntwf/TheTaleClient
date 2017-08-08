//
//  UIImage.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 06/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

extension UIImage {
  struct RotationOptions: OptionSet {
    let rawValue: Int
    
    static let flipOnVerticalAxis   = RotationOptions(rawValue: 1)
    static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
  }
  
  func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
    guard let cgImage = self.cgImage else { return nil }
    
    let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
    let transform         = CGAffineTransform(rotationAngle: rotationInRadians)
    var rect              = CGRect(origin: .zero, size: self.size).applying(transform)
    
    rect.origin = .zero
    
    let renderer = UIGraphicsImageRenderer(size: rect.size)
    return renderer.image { renderContext in
      renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
      renderContext.cgContext.rotate(by: rotationInRadians)
      
      let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
      let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
      renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
      
      let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
      renderContext.cgContext.draw(cgImage, in: drawRect)
    }
  }
}

extension UIImage {
  public convenience init?(prefix: String, imagesNamed: [(String, Double)], size: CGSize) {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    
    for (id, image) in imagesNamed.enumerated() {
      let (imageName, angle) = image
      
      if id == 0 {
        let backgroundImage = UIImage(named: "\(prefix)_\(imageName)")
        backgroundImage?.draw(in: CGRect(origin: .zero, size: size))
        
      } else {
        let overlayImage = UIImage(named: "\(prefix)_\(imageName)")?.rotated(by: Measurement(value: angle, unit: .degrees))
        overlayImage?.draw(in: CGRect(origin: .zero, size: size))
      }
    }
    
    guard let finalImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
    UIGraphicsEndImageContext()
    
    self.init(cgImage: finalImage)
  }
}
