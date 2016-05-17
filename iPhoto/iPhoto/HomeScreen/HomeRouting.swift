//
//  HomeRouting.swift
//  iPhoto
//
//  Created by ngodacdu on 5/15/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class HomeRouting: NSObject {

    class var shareInstance: HomeRouting {
        struct Instance {
            static let instance = HomeRouting()
        }
        return Instance.instance
    }
    
    private func presentViewController(controller: UIViewController?, from: HomeViewController) {
        if let controller = controller {
            controller.modalTransitionStyle = .CrossDissolve
            from.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func presentCameraViewController(from: HomeViewController) {
        
    }
    
    func presentPhotoCollageViewController(from: HomeViewController) {
        let photoCollageVC = StoryBoardManager.shareInstance.photoCollageViewController()
        presentViewController(photoCollageVC, from: from)
    }
    
    func presentFreeStyleViewController(from: HomeViewController) {
        
    }
    
    func presentPhotoEditViewController(from: HomeViewController) {
        
    }
    
    func presentDownloadStickerViewController(from: HomeViewController) {
        
    }
    
    func presentSettingViewController(from: HomeViewController) {
        
    }
    
}
