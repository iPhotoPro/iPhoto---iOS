//
//  ViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/7/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import DLPhotoPicker

class HomeViewController: UIViewController {
    
    private let kPhotoTopPadding: CGFloat = 10
    private let kNumPhotoPerRow: Int = 3
    private var photoSize: CGSize = CGSizeZero

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func show(sender: AnyObject) {
        if let picker = StoryBoardManager.shareInstance.assetPhotoViewController() {
            if let controller = picker.visibleViewController as? IOAssetPhotoViewController {
                controller.limit = 5
                controller.collectionDelegate = self
            }
            presentViewController(picker, animated: true, completion: nil)
        }
    }

}

extension HomeViewController: IOAssetPhotoViewControllerDelegate {
    
    func collectionViewDidSelectedPhotos(photoAssets: [DLPhotoAsset]) {
        //TODO
    }
    
}
