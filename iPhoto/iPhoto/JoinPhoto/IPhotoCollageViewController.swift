//
//  IPhotoCollageViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/14/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

enum Action {
    case Layout
    case Padding
}

class IPhotoCollageViewController: UIViewController {
    
    let kDefaultCollageLayoutIndex: Int = 0
    let partition: CGFloat = 4.0
    let kAnimation: NSTimeInterval = 0.3

    @IBOutlet weak var photoCollageContainerView: UIView!
    @IBOutlet weak var collageContainerView: UIView!
    private var mainLayout: IPhotoCollageMainLayoutView!
    var dataSource: [CGSize] = [CGSize]()
    
    private var currentAction: Action = .Layout
    private var layoutView: IPhotoCollageLayoutListView?
    private var paddingView: IPaddingSliderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePhotoCollageLayoutList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func backHomeViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func preparePhotoCollageLayoutList() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var parentRect = CGRectZero
            if let bounds = weakSelf?.collageContainerView.bounds {
                parentRect = bounds
            }
            IPhotoCollageManager.shareInstance.readPhotoCollageJsonFile(parentRect)
            dispatch_async(dispatch_get_main_queue(), {
                if let layoutView = self.getCurrentActionView(.Layout) as? IPhotoCollageLayoutListView {
                    layoutView.frame = self.photoCollageContainerView.bounds
                    layoutView.delegate = self
                    self.photoCollageContainerView.addSubview(layoutView)
                    self.prepareCollageMainLayout(nil)
                }
            })
        }
    }
    
    private func prepareCollageMainLayout(indexPath: NSIndexPath?) {
        if mainLayout == nil {
            mainLayout = IPhotoCollageMainLayoutView.loadFromNib()
            mainLayout.frame = collageContainerView.bounds
            collageContainerView.addSubview(mainLayout)
        }
        var index = 0
        if let indexPath = indexPath {
            index = indexPath.row
        }
        let datas = IPhotoCollageManager.shareInstance.photoCollages
        if datas.count > index {
            let layouts = datas[index].layouts
            mainLayout.reloadCollageViewWithData(layouts)
        }
    }
    
    private func getCurrentActionView(action: Action) -> UIView? {
        var view: UIView?
        switch action {
        case .Layout:
            if layoutView == nil {
                layoutView = IPhotoCollageLayoutListView.loadFromNib()
            }
            view = layoutView
            break
        case .Padding:
            if paddingView == nil {
                paddingView = IPaddingSliderView.loadFromNib()
            }
            view = paddingView
            break
        }
        return view
    }
    
    private func addActionView() {
        if let currentActionView = getCurrentActionView(currentAction) {
            currentActionView.frame = photoCollageContainerView.bounds
            if currentActionView.isKindOfClass(IPhotoCollageLayoutListView) {
                (currentActionView as! IPhotoCollageLayoutListView).delegate = self
            } else if currentActionView.isKindOfClass(IPaddingSliderView) {
                (currentActionView as! IPaddingSliderView).delegate = self
            }
            photoCollageContainerView.addSubview(currentActionView)
            UIView.animateWithDuration(kAnimation) {
                currentActionView.alpha = 1.0
            }
        }
    }
    
    private func removeActionView() {
        UIView.animateWithDuration(kAnimation) {
            if let currentActionView = self.getCurrentActionView(self.currentAction) {
                currentActionView.alpha = 1.0
                currentActionView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func didTouchUpInsideLayoutButton(sender: AnyObject) {
        removeActionView()
        currentAction = .Layout
        addActionView()
    }
    
    @IBAction func didTouchUpInsidePaddingButton(sender: AnyObject) {
        removeActionView()
        currentAction = .Padding
        addActionView()
    }

}

extension IPhotoCollageViewController: IPhotoCollageLayoutListViewDelegate, IPaddingSliderViewDelegate {
    
    func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
        prepareCollageMainLayout(indexPath)
    }
    
    func didChangeValue(slider: IPSlider, value: Int) {
        mainLayout.updatePadding(CGFloat(value))
    }
    
}
