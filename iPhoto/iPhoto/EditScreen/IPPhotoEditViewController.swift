//
//  IPPhotoEditViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/9/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import DLPhotoPicker

class IPPhotoEditViewController: UIViewController {
    
    var asset: DLPhotoAsset?
    @IBOutlet weak var imageView: UIImageView!
    private var originImage: UIImage!
    @IBOutlet weak var controlContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func computeImageViewSize() -> CGSize {
        let scale = UIScreen.mainScreen().scale
        var size = CGSizeZero
        size.width = imageView.frame.width * scale
        size.height = imageView.frame.height * scale
        return size
    }
    
//    @IBAction func didChangeSliderValue(sender: AnyObject) {
//        if let slider = sender as? UISlider {
//            let image = IPImageAdjustment.shareInstance.filterContrast(
//                originImage,
//                contrast: CGFloat(slider.value)
//            )
//            dispatch_async(dispatch_get_main_queue(), {
//                self.imageView.image = image
//            })
//        }
//    }

}

extension IPPhotoEditViewController {
    
    //MARK: Prepare before edit image
    private func prepare() {
        prepareActions()
        prepareImageNeedEdit()
    }
    
    private func prepareActions() {
        if let actionView = IPActionAdjustment.loadFromNib() {
            actionView.frame = controlContainerView.bounds
            controlContainerView.addSubview(actionView)
        }
    }
    
    private func prepareImageNeedEdit() {
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let currentAsset = weakSelf?.asset {
                if let size = weakSelf?.computeImageViewSize() {
                    currentAsset.requestThumbnailImageWithSize(size) { (image: UIImage!, info: [NSObject : AnyObject]!) in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imageView.image = image
                            self.originImage = image
                        })
                    }
                }
            }
        }
    }
    
    
    //MARK: Process image
    
    
}
