//
//  IOAssetPhotoEmptyView.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IOAssetPhotoEmptyView: UIView {

    class func loadFromNib() -> IOAssetPhotoEmptyView? {
        let bundle = NSBundle.mainBundle().loadNibNamed("IOAssetPhotoEmptyView", owner: self, options: nil)
        return bundle.first as? IOAssetPhotoEmptyView
    }
    
}
