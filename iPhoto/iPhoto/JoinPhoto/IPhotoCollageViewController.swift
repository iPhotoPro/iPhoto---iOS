//
//  IPhotoCollageViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/14/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IPhotoCollageViewController: UIViewController {
    
    @IBOutlet weak var collageLayoutContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        IPhotoCollageManager.shareInstance.readPhotoCollageJsonFile(collageLayoutContainer.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let index = 1
        IPhotoCollageManager.shareInstance.renderSubViewFrom(index, parentView: collageLayoutContainer)
    }

}
