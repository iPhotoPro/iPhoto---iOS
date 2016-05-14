//
//  ViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/7/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var collageButton: UIButton!
    @IBOutlet weak var freeStyleButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareHomeViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func prepareHomeViewController() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func didTouchUpInsideCameraButton(sender: AnyObject) {
        
    }
    
    @IBAction func didTouchUpInsideCollageButton(sender: AnyObject) {
        
    }

    @IBAction func didTouchUpInsideFreeStyleButton(sender: AnyObject) {
        
    }
    
    @IBAction func didTouchUpInsideEditPhotoButton(sender: AnyObject) {
        
    }
    
    @IBAction func didTouchUpInsideStickerButton(sender: AnyObject) {
        
    }
    
    @IBAction func didTouchUpInsideSettingButton(sender: AnyObject) {
        
    }
    
}
