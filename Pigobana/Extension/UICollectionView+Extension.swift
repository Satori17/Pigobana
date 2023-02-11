//
//  UICollectionView+Extension.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 23.09.22.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib { UINib(nibName: identifier, bundle: nil) }
}

extension UICollectionView {
    public func registerNib<T: UICollectionViewCell>(class: T.Type) {
        self.register(T.nibFile, forCellWithReuseIdentifier: T.identifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(fromClass type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T ?? T()
    }
    
//    public func dequeueReusableCell<Cell: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
//        let identifier = String(describing: Cell.self)
//        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
//            fatalError("Error happened for cell id: \(identifier) at \(indexPath))")
//        }
//        return cell
//    }
    
    public func layoutViews(quantity: [Any]) {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            switch quantity.count {
            case 0..<4:
                layout.itemSize.width = 153
            case 4..<8:
                layout.itemSize.width = 110
            case 8..<10:
                layout.itemSize.width = 90
            case 10..<14:
                layout.itemSize.width = 60
            default:
                layout.itemSize.width = 50
            }
        }
    }
}
