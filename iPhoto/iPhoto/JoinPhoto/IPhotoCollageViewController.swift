//
//  IPhotoCollageViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/14/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

enum Action {
    case Layout
    case Padding
    case Radius
    case Border
    case Color
}

var kPaddingDefault: Float = 4
var kRadiusDefault: Float = 0
var kBorderDefault: Float = 0

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
    private var borderView: IBorderSliderView?
    private var backgroundColorView: IBackgroundColor?
    
    @IBOutlet weak var layoutActionButton: UIButton!
    @IBOutlet weak var paddingActionButton: UIButton!
    @IBOutlet weak var radiusActionButton: UIButton!
    @IBOutlet weak var borderActionButton: UIButton!
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
        case .Border:
            if borderView == nil {
                borderView = IBorderSliderView.loadFromNib()
            }
            view = borderView
            break
        case .Color:
            if backgroundColorView == nil {
                backgroundColorView = IBackgroundColor.loadFromNib()
            }
            view = backgroundColorView
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
            } else if currentActionView.isKindOfClass(IRadiusSliderView) {
                (currentActionView as! IRadiusSliderView).delegate = self
            } else if currentActionView.isKindOfClass(IBorderSliderView) {
                (currentActionView as! IBorderSliderView).delegate = self
            }
            currentActionView.alpha = 0.0
            photoCollageContainerView.addSubview(currentActionView)
            view.bringSubviewToFront(photoCollageContainerView)
            UIView.beginAnimations(nil, context: nil)
            currentActionView.alpha = 1.0
            UIView.commitAnimations()
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
        if currentAction == .Border {
            borderActionButton.setImage(UIImage(named: "collage-border-select"), forState: .Normal)
        } else {
            borderActionButton.setImage(UIImage(named: "collage-border"), forState: .Normal)
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
    
    @IBAction func didTouchUpInsideBorderButton(sender: AnyObject) {
        if currentAction != .Border {
            removeActionView()
            currentAction = .Border
            addActionView()
            updateActionButtonState()
        }
    }
    
    @IBAction func didTouchUpInsideColorButton(sender: AnyObject) {
        if currentAction != .Color {
            removeActionView()
            currentAction = .Color
            addActionView()
            updateActionButtonState()
        }
    }
    
}

extension IPhotoCollageViewController: IPhotoCollageLayoutListViewDelegate, IPaddingSliderViewDelegate, IRadiusSliderViewDelegate, IBorderSliderViewDelegate {
    
    func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row != currentLayoutIndex {
            currentLayoutIndex = indexPath.row
            prepareCollageMainLayout(indexPath)
            paddingView?.defaultSilder()
            radiusView?.defaultSilder()
        }
    }
    
    func didChangeValuePadding(slider: ASValueTrackingSlider, value: Float) {
        mainLayout.updatePadding(CGFloat(value))
    }
    
    func didChangeValueRadius(slider: ASValueTrackingSlider, value: Float) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            kProcessRadiusImageViewNotificationName,
            object: self,
            userInfo: ["radius-value" : value]
        )
    }
    
    func didChangeValueBorder(slider: ASValueTrackingSlider, value: Float) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            kProcessBorderImageViewNotificationName,
            object: self,
            userInfo: ["border-value" : value]
        )
    }
    
    func didSelectedBorderColor(colorView: IBorderColor, color: UIColor) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            kProcessBorderColorNotificationName,
            object: self,
            userInfo: ["border-color" : color]
        )
    }
    
    func didSelectedBorderType(type: BorderOption) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            kProcessBorderTypeNotificationName,
            object: self,
            userInfo: ["border-type" : type.rawValue]
        )
    }
    
}
