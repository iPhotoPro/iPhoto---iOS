//
//  CustomNavigationBar.swift
//  IOFetchAssetPhoto
//
//  Created by ngodacdu on 5/6/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {

    class func loadFromNib() -> CustomNavigationBar? {
        let bundle = NSBundle.mainBundle().loadNibNamed("CustomNavigationBar", owner: self, options: nil)
        return bundle.first as? CustomNavigationBar
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var title: String = "All Photo" {
        didSet {
            contentLabel.text = title
        }
    }
    
}
