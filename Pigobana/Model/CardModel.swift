//
//  CardModel.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 17.07.21.
//

import UIKit

struct CardModel {
    let name: String
    private var image: UIImage? = nil
    var suit: Suit = .unknown
    
    init(name: String) {
        self.name = name
        self.suit = getSuit(withName: name)
        if let cardImage = UIImage(named: name) {
            self.image = cardImage
        }
    }
    
    private func getSuit(withName name: String) -> Suit {
        if let lastChar = name.last?.lowercased() {
            let currentSuit = Suit.allCases.filter{ $0.rawValue.hasPrefix(lastChar) }.first
            if let currentSuit {
                return currentSuit
            }
        }
        return .unknown
    }
}
