//
//  CGImagePropertyOrientation.swift
//  style transfer
//
//  Created by yuchenxi on 2019/5/6.
//  Copyright © 2019 yuchenxi2000. All rights reserved.
//
//  Published under MIT License.
//

/*
 Abstract:
 Core Graphics utility extensions used in the sample code.
 
 https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml
 
 LICENSE: APACHE Version 2.0, January 2004 http://www.apache.org/licenses/
 
 modified by yuchenxi.
 */

import UIKit
import ImageIO

extension CGImagePropertyOrientation {
    /**
     Converts a `UIImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     
     - Tag: ConvertOrientation
     */
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

