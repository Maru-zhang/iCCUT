//
//  CCMediaTransition.swift
//  iCCUT
//
//  Created by Maru on 16/3/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//


class CCMediaTransition: UIPresentationController,UIViewControllerTransitioningDelegate {

    /// 需要显示的View
    var targetView: UIView? = nil
    /// 黑色蒙版
    var dimmingView: UIView? = nil
    
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
    
    
    // MARK: - 两组对应的方法，实现自定义presentation
    override func presentationTransitionWillBegin() {
        
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        
    }
    
    override func dismissalTransitionWillBegin() {
        
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        
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
        let containerViewBounds = self.containerView?.bounds
        let presentedViewContentSize = self.sizeForChildContentContainer(self.presentedViewController, withParentContainerSize: (containerViewBounds?.size)!)
        let presentedViewControllerFrame = CGRectMake(containerViewBounds!.origin.x, CGRectGetMaxY(containerViewBounds!) - presentedViewContentSize.height, (containerViewBounds?.size.width)!, presentedViewContentSize.height)
        return presentedViewControllerFrame
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

