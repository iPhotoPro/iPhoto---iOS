//
//  IOAsettPhotoViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import DLPhotoPicker

class IOAsettPhotoViewController: DLPhotoPickerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HomeViewController {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        switch viewController {
        case is DLPhotoTableViewController:
            customPhotoTableViewController(viewController as? DLPhotoTableViewController)
            break
        case is DLPhotoCollectionViewController:
            customPhotoCollectionViewController(viewController as? DLPhotoCollectionViewController)
            break
        default:
            break
        }
        
    }
    
    private func customPhotoTableViewController(controller: DLPhotoTableViewController?) {
        
    }
    
    private func customPhotoCollectionViewController(controller: DLPhotoCollectionViewController?) {
        controller?.collectionView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
}
