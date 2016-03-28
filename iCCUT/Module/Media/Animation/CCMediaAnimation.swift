//
//  CCMediaAnimation.swift
//  iCCUT
//
//  Created by Maru on 16/3/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

class CCMediaAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if let isAnimated = transitionContext?.isAnimated() {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /*
         fromViewController,toViewController,containerView是不变的，当一个转场动作开始到结束都是不变的，而
         fromView，toView,isPresentingView则是相对改变的，因此获取该对象的时候不能通过控制器获取
         */
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let isPresenting = (toViewController?.presentingViewController == fromViewController)
        
        var fromViewFinalFrame = transitionContext.finalFrameForViewController(fromViewController!)
        var toViewInitialFrame = transitionContext.initialFrameForViewController(toViewController!)
        let toViewFinalFrame = transitionContext.finalFrameForViewController(toViewController!)
        
        if toView != nil {
            containerView?.addSubview(toView!)
        }
        
        // 转场开始前的视图位置
        if isPresenting {
            toViewInitialFrame.origin = CGPointMake(CGRectGetMinX(containerView!.bounds),-CGRectGetHeight((toView?.frame)!))
            toViewInitialFrame.size = toViewFinalFrame.size
            toView?.frame = toViewInitialFrame
        } else {
            fromViewFinalFrame = CGRectOffset(fromView!.frame, 0, CGRectGetHeight(fromView!.frame))
        }
        
        let transitionDuration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(transitionDuration, animations: {
            if isPresenting {
                toView?.frame = toViewFinalFrame
            }
            else {
                fromView?.frame = CGRectMake(0, -CGRectGetHeight(fromViewFinalFrame), fromViewFinalFrame.size.width, fromViewFinalFrame.size.height)
            }
            
        }) { (finished: Bool) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
}
