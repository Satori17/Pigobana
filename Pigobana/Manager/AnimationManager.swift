//
//  AnimationManager.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 22.09.22.
//

import UIKit

protocol AnimationManagerDelegate: AnyObject {
    func pressingAnimation(_ sender: UIButton)
    func movingAnimation(from cell: UICollectionViewCell, to view: UIView, completion: @escaping () -> Void)
    func reorderAnimation(for cards: [CardModel], on collectionView: UICollectionView)
}

final class AnimationManager: NSObject, CAAnimationDelegate, AnimationManagerDelegate {
    //MARK: - Properties
    
    private let basicAnimation = CABasicAnimation()
    
    //MARK: - Methods
    
    func pressingAnimation(_ sender: UIButton) {
        basicAnimation.keyPath = AnimationKey.backgroundColor
        let pressingAnim = basicAnimation
        pressingAnim.fromValue = UIColor.gray.withAlphaComponent(0.5).cgColor
        pressingAnim.duration = 0.4
        sender.layer.add(pressingAnim, forKey: nil)
    }
    
    func movingAnimation(from cell: UICollectionViewCell, to view: UIView, completion: @escaping () -> Void) {
        cell.frame.size.width = 230
        
        UIView.animate(withDuration: 0.5) {
            cell.frame.origin.x = view.frame.origin.x
            cell.frame.origin.y = -view.frame.origin.y - 70
        } completion: { _ in
            completion()
        }
    }
    
    func reorderAnimation(for cards: [CardModel], on collectionView: UICollectionView) {
        UIView.animate(withDuration: 0.2) {
            collectionView.layoutViews(quantity: cards)
        }
    }
}
