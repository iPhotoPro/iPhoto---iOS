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
    case Radius
    case Color
}

var kPaddingDefault: Int = 10

class IPhotoCollageViewController: UIViewController {
    
    let kDefaultCollageLayoutIndex: Int = 0
    let partition: CGFloat = 4.0
    let kAnimation: NSTimeInterval = 0.3

    @IBOutlet weak var photoCollageContainerView: UIView!
    @IBOutlet weak var collageContainerView: UIView!
    private var mainLayout: IPhotoCollageMainLayoutView!
    private var currentLayoutIndex: Int = 0
    private var dataSource: [CGSize] = [CGSize]()
    
    private var currentAction: Action = .Layout
    private var layoutView: IPhotoCollageLayoutListView?
    private var paddingView: IPaddingSliderView?
    private var radiusView: IRadiusSliderView?
    
    @IBOutlet weak var layoutActionButton: UIButton!
    @IBOutlet weak var paddingActionButton: UIButton!
    @IBOutlet weak var radiusActionButton: UIButton!
    @IBOutlet weak var colorActionButton: UIButton!
    
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
        if datas.layouts.count > index {
            let layouts = datas.layouts[index]
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
        case .Radius:
            if radiusView == nil {
                radiusView = IRadiusSliderView.loadFromNib()
            }
            view = radiusView
            break
        case .Color:
            
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
    
    private func updateActionButtonState() {
        if currentAction == .Layout {
            layoutActionButton.setImage(UIImage(named: "collage-collage-select"), forState: .Normal)
        } else {
            layoutActionButton.setImage(UIImage(named: "collage-collage"), forState: .Normal)
        }
        if currentAction == .Padding {
            paddingActionButton.setImage(UIImage(named: "collage-padding-select"), forState: .Normal)
        } else {
            paddingActionButton.setImage(UIImage(named: "collage-padding"), forState: .Normal)
        }
        if currentAction == .Radius {
            radiusActionButton.setImage(UIImage(named: "collage-radius-select"), forState: .Normal)
        } else {
            radiusActionButton.setImage(UIImage(named: "collage-radius"), forState: .Normal)
        }
        if currentAction == .Color {
            colorActionButton.setImage(UIImage(named: "collage-color-select"), forState: .Normal)
        } else {
            colorActionButton.setImage(UIImage(named: "collage-color"), forState: .Normal)
        }
    }
    
    @IBAction func didTouchUpInsideLayoutButton(sender: AnyObject) {
        if currentAction != .Layout {
            removeActionView()
            currentAction = .Layout
            addActionView()
            updateActionButtonState()
        }
    }
    
    @IBAction func didTouchUpInsidePaddingButton(sender: AnyObject) {
        if currentAction != .Padding {
            removeActionView()
            currentAction = .Padding
            addActionView()
            updateActionButtonState()
        }
    }

    @IBAction func didTouchUpInsideRadiusButton(sender: AnyObject) {
        if currentAction != .Radius {
            removeActionView()
            currentAction = .Radius
            addActionView()
            updateActionButtonState()
        }
    }
    
    @IBAction func didTouchUpInsideColorButton(sender: AnyObject) {
        if currentAction != .Color {
            removeActionView()
            currentAction = .Color
            //
            updateActionButtonState()
        }
    }
    
}

extension IPhotoCollageViewController: IPhotoCollageLayoutListViewDelegate, IPaddingSliderViewDelegate {
    
    func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row != currentLayoutIndex {
            currentLayoutIndex = indexPath.row
            prepareCollageMainLayout(indexPath)
            paddingView?.defaultSilder()
        }
    }
    
    func didChangeValue(slider: IPSlider, value: Int) {
        mainLayout.updatePadding(CGFloat(value))
    }
    
}
