//
//  CCMediaTransition.swift
//  iCCUT
//
//  Created by Maru on 16/3/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//


class CCMediaTransition: UIPresentationController,UIViewControllerTransitioningDelegate {

    
    /// 需要显示的View
    private var targetView: UIView? = nil
    /// 黑色蒙版
    private var dimmingView: UIView? = nil
    /// 圆角度
    private let radius: CGFloat = 16
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        presentedViewController.modalPresentationStyle = .Custom
    }
    
    /**
     告诉UIKit，为哪一个View添加动画
     
     - returns: 需要添加动画的View
     */
    override func presentedView() -> UIView? {
        return targetView
    }
    
    // MARK: - Private Method
    func dimmingViewTapped() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 两组对应的方法，实现自定义presentation
    override func presentationTransitionWillBegin() {
        
        let presentationWrapperView = UIView(frame: self.frameOfPresentedViewInContainerView()) // 添加阴影效果
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowRadius = 13
        presentationWrapperView.layer.shadowOffset = CGSizeMake(0, 6)
        /// 在重写父类的presentedView方法中，返回了self.presentationWrappingView，这个方法表示需要添加动画效果的视图
        /// 这里对self.presentationWrappingView赋值，从后面的代码可以看到这个视图处于视图层级的最上层
        self.targetView = presentationWrapperView
        
        let presentationRoundedCornerView = UIView(frame: UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, 0, 0))) // 添加圆角效果
        presentationRoundedCornerView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        presentationRoundedCornerView.layer.cornerRadius = radius
        presentationRoundedCornerView.layer.masksToBounds = true
        
        let presentedViewControllerWrapperView = UIView(frame: UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, 0, 0)))
        presentedViewControllerWrapperView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        let presentedViewControllerView = super.presentedView()
        presentedViewControllerView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        presentedViewControllerView?.frame = presentedViewControllerWrapperView.bounds
        
        presentedViewControllerWrapperView.addSubview(presentedViewControllerView!)
        presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
        presentationWrapperView.addSubview(presentationRoundedCornerView)
        
        let dimmingView = UIView(frame: (self.containerView?.bounds)!)
        dimmingView.backgroundColor = UIColor.blackColor()
        dimmingView.opaque = false
        dimmingView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        self.dimmingView = dimmingView
        self.containerView?.addSubview(dimmingView)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        self.dimmingView?.alpha = 0
        transitionCoordinator?.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView?.alpha = 0.5
            }, completion: nil)
        
    }
    
    /// 如果present没有完成，把dimmingView和wrappingView都清空，这些临时视图用不到了
    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            self.targetView = nil
            self.dimmingView = nil
        }
    }
    
    /// dismiss开始时，让dimmingView完全透明，这个动画和animator中的动画同时发生
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView?.alpha = 0
            }, completion: nil)
    }
    
    /// dismiss结束时，把dimmingView和wrappingView都清空，这些临时视图用不到了
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            self.targetView = nil
            self.dimmingView = nil
        }
    }
    
    

}

// MARK: - Autolayout
extension CCMediaTransition {
    override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        super.preferredContentSizeDidChangeForChildContentContainer(container)
        
        if let container = container as? UIViewController where
            container == self.presentedViewController{
            self.containerView?.setNeedsLayout()
        }
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let container = container as? UIViewController where
            container == self.presentedViewController{
            return container.preferredContentSize
        }
        else {
            return super.sizeForChildContentContainer(container, withParentContainerSize: parentSize)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRectMake(0, 63, CGRectGetWidth((containerView?.bounds)!), 300)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        self.dimmingView?.frame = (self.containerView?.bounds)!
        self.targetView?.frame = self.frameOfPresentedViewInContainerView()
    }
}

// MARK: - 实现协议UIViewControllerTransitioningDelegate
extension CCMediaTransition {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CCMediaAnimation()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CCMediaAnimation()
    }
}

