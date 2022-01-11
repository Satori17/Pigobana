//
//  CardModel.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 17.07.21.
//

import UIKit


enum CardSuit {
    case Clubs
    case Diamonds
    case Hearts
    case Spades
}


struct CardModel {
    var name: String
    var cardSuit: CardSuit!
}


struct CardsData {
    var cards: [CardModel]!
    
    
    mutating func defineCardType(_ cardsArray: inout [CardModel]) {
        for card in 0..<cardsArray.count {
            if cardsArray[card].name.hasSuffix("C") {
                cardsArray[card].cardSuit = .Clubs
            } else if cardsArray[card].name.hasSuffix("D") {
                cardsArray[card].cardSuit = .Diamonds
            } else if cardsArray[card].name.hasSuffix("H") {
                cardsArray[card].cardSuit = .Hearts
            } else {
                cardsArray[card].cardSuit = .Spades
            }
        }
    }
}
