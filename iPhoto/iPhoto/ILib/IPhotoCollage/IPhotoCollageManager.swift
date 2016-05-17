//
//  IPhotoCollageManagement.swift
//  iPhoto
//
//  Created by ngodacdu on 5/14/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ILayout: NSObject {
    var size: CGSize = CGSizeZero
    var hPadding: CGFloat = 0.0
    var vPadding: CGFloat = 0.0
}

class IPhotoCollage: NSObject {
    
    var layouts: [ILayout] = [ILayout]()
    
}

class IPhotoCollageManager: NSObject {
    
    let fileName = "PhotoCollage"
    let fileType = "json"
    let kPartition: CGFloat = 6
    var photoCollages: [IPhotoCollage] = [IPhotoCollage]()
    
    class var shareInstance: IPhotoCollageManager {
        struct Instance {
            static let instance = IPhotoCollageManager()
        }
        return Instance.instance
    }
    
    func readPhotoCollageJsonFile(parentFrame: CGRect) {
        photoCollages.removeAll(keepCapacity: false)
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType) {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data)
                if let collageArray = json["collage"].array {
                    for collageJson in collageArray {
                        if let layoutJson = collageJson["layout"].array {
                            let photoCollage = IPhotoCollage()
                            for layout in layoutJson {
                                let newLayout = ILayout()
                                
                                let widthUnit = parentFrame.width / kPartition
                                let heightUnit = parentFrame.height / kPartition
                                let width = CGFloat(layout["width"].floatValue) * widthUnit
                                let height = CGFloat(layout["height"].floatValue) * heightUnit
                                newLayout.size = CGSize(width: width, height: height)
                                newLayout.hPadding = CGFloat(layout["h-padding"].floatValue)
                                newLayout.vPadding = CGFloat(layout["v-padding"].floatValue)
                                
                                photoCollage.layouts.append(newLayout)
                            }
                            photoCollages.append(photoCollage)
                        }
                    }
                }
            }
        }
    }

}
