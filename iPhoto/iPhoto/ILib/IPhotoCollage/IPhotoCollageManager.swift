//
//  IPhotoCollageManagement.swift
//  iPhoto
//
//  Created by ngodacdu on 5/14/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import SwiftyJSON

class IPhotoCollage: NSObject {
    
    var frames: [CGRect] = [CGRect]()
    
    override init() {
        super.init()
    }
    
}

class IPhotoCollageManager: NSObject {
    
    let fileName = "PhotoCollage"
    let fileType = "json"
    var photoCollages: [IPhotoCollage] = [IPhotoCollage]()
    
    class var shareInstance: IPhotoCollageManager {
        struct Instance {
            static let instance = IPhotoCollageManager()
        }
        return Instance.instance
    }
    
    func readPhotoCollageJsonFile(parentFrame: CGRect) {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType) {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data)
                if let collageArray = json["collage"].array {
                    for collageJson in collageArray {
                        if let layoutJson = collageJson["layout"].array {
                            let photoCollage = IPhotoCollage()
                            for layout in layoutJson {
                                var frame = CGRectZero
                                let x = layout["x"]
                                let y = layout["y"]
                                let width = layout["width"]
                                let height = layout["height"]
                                frame.origin.x = parentFrame.size.width * CGFloat(x["numerator"].floatValue / x["denominator"].floatValue)
                                frame.origin.y = parentFrame.size.height * CGFloat(y["numerator"].floatValue / y["denominator"].floatValue)
                                frame.size.width = parentFrame.size.width * CGFloat(width["numerator"].floatValue / width["denominator"].floatValue)
                                frame.size.height = parentFrame.size.height * CGFloat(height["numerator"].floatValue / height["denominator"].floatValue)
                                photoCollage.frames.append(frame)
                            }
                            photoCollages.append(photoCollage)
                        }
                    }
                }
            }
        }
    }
    
    func renderSubViewFrom(collageIndex: Int, parentView: UIView) {
        if photoCollages.count > collageIndex {
            let photoCollage = photoCollages[collageIndex]
            for frame in photoCollage.frames {
                let subView = UIView(frame: frame)
                subView.backgroundColor = UIColor.redColor()
                parentView.addSubview(subView)
            }
        }
    }

}
