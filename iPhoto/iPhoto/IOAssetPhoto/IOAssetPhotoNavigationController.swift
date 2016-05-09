//
//  IOAssetPhotoNavigationController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IOAssetPhotoNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toolbarHidden = true
    }

}
