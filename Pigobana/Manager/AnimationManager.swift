//
//  AnimationManager.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 22.09.22.
//

import UIKit

final class AnimationManager: NSObject, CAAnimationDelegate {
    
    //MARK: - Properties
    private let basicAnimation = CABasicAnimation()
    private let animation = CAKeyframeAnimation()
    private let bezierPath = UIBezierPath()
    
    func pressingAnimation(_ sender: UIButton) {
        basicAnimation.keyPath = AnimationKey.backgroundColor
        let pressingAnim = basicAnimation
        pressingAnim.fromValue = UIColor.gray.withAlphaComponent(0.5).cgColor
        pressingAnim.duration = 0.4
        sender.layer.add(pressingAnim, forKey: nil)
    }
    
    func movingAnimation(fromView: UIView, toView: UIView, completion: @escaping () -> ()) {        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion()
        })
        
        bezierPath.move(to: fromView.center)
        bezierPath.addLine(to: toView.center)
        //move
        let moveAnimation = CAKeyframeAnimation(keyPath: AnimationKey.position)
        moveAnimation.path = bezierPath.cgPath
        moveAnimation.isRemovedOnCompletion = true
//        //scale
//        let scaleAnimation = CABasicAnimation(keyPath: AnimationKey.transform)
//        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
//        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
//        scaleAnimation.isRemovedOnCompletion = true
//        //rotate
//        let rotationAnimation = CABasicAnimation(keyPath: AnimationKey.rotationZ)
//        rotationAnimation.toValue = NSNumber(value: -CGFloat.pi * 99 / 100)
//        rotationAnimation.isCumulative = true
//        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
//        rotationAnimation.isRemovedOnCompletion = true
        
//        let animGroup = CAAnimationGroup()
//        animGroup.delegate = self
//        animGroup.setValue(AnimationKey.curvedAnim, forKey: AnimationKey.name)
        let animation = CAAnimation()
        animation.delegate = self
        animation.setValue(AnimationKey.curvedAnim, forKey: AnimationKey.name)
        animation.duration = 0.5
        fromView.layer.add(animation, forKey: AnimationKey.curvedAnim)
        //animGroup.animations = [moveAnimation, scaleAnimation]
//        if isRotated {
//            animGroup.animations?.append(rotationAnimation)
//        }
//        animGroup.duration = 0.5
//        fromView.layer.add(animGroup, forKey: AnimationKey.curvedAnim)
        CATransaction.commit()
        
    }
}
