//
//  IPhotoCollageManagement.swift
//  iPhoto
//
//  Created by ngodacdu on 5/14/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ISize: NSObject {
    var size: CGSize = CGSizeZero
    var hPadding: CGFloat = 0.0
    var vPadding: CGFloat = 0.0
}

class ISection: NSObject {
    var numColumn: Int = 0
    var sizes: [ISize] = [ISize]()
}

class ILayout: NSObject {
    var sections: [ISection] = [ISection]()
}

class IPhotoCollage: NSObject {
    var layouts: [ILayout] = [ILayout]()
}

class IPhotoCollageManager: NSObject {
    
    let fileName = "PhotoCollage"
    let fileType = "json"
    let kPartition: CGFloat = 6
    var photoCollages: IPhotoCollage = IPhotoCollage()
    
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
                if let collages = json["collage"].array {
                    for layout in collages {
                        let newLayout = ILayout()
                        if let sections = layout["layout"].array {
                            for section in sections {
                                let newSection = ISection()
                                let column = section["column"].intValue
                                newSection.numColumn = column
                                if let sizes = section["sizes"].array {
                                    for size in sizes {
                                        let newSize = ISize()
                                        let widthUnit = parentFrame.width / kPartition
                                        let heightUnit = parentFrame.height / kPartition
                                        newSize.size.width = CGFloat(size["width"].floatValue) * widthUnit
                                        newSize.size.height = CGFloat(size["height"].floatValue) * heightUnit
                                        newSize.hPadding = CGFloat(size["h-padding"].floatValue)
                                        newSize.vPadding = CGFloat(size["v-padding"].floatValue)
                                        newSection.sizes.append(newSize)
                                    }
                                }
                                newLayout.sections.append(newSection)
                            }
                        }
                        photoCollages.layouts.append(newLayout)
                    }
                }
            }
        }
    }

}
