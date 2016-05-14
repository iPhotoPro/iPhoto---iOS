//
//  StoryBoardManager.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class StoryBoardManager: NSObject {
    
    class var shareInstance: StoryBoardManager {
        struct Instance {
            static let instance = StoryBoardManager()
        }
        return Instance.instance
    }
    
    private func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    private func photoStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Photo", bundle: nil)
    }
    
    func homeViewController() -> HomeViewController? {
        return mainStoryBoard().instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
    }
    
    func assetPhotoViewController() -> IOAssetPhotoNavigationController? {
        return photoStoryBoard().instantiateViewControllerWithIdentifier("IOAssetPhotoNavigationController") as? IOAssetPhotoNavigationController
    }
    
    func menuViewController() -> IOMenuNavigationController? {
        return photoStoryBoard().instantiateViewControllerWithIdentifier("IOMenuNavigationController") as? IOMenuNavigationController
    }
    
    func photoEditViewController() -> IPPhotoEditViewController? {
        return photoStoryBoard().instantiateViewControllerWithIdentifier("IPPhotoEditViewController") as? IPPhotoEditViewController
    }
    
    func photoCollageViewController() -> IPhotoCollageViewController? {
        return photoStoryBoard().instantiateViewControllerWithIdentifier("IPhotoCollageViewController") as? IPhotoCollageViewController
    }

}
