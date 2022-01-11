//
//  CardsUI.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 20.07.21.
//

import UIKit

extension PlayVC {
    
    func closedCardsUI (exist: Bool) {
        if exist == true {
            closedCards.layer.cornerRadius = 9
            closedCards.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
            closedCards.layer.borderWidth = (closedCards.frame.width)/30
            closedCards.setBackgroundImage(UIImage(named: "blue_background"), for: .normal)
            
            deckOfCards.layer.cornerRadius = 9
            deckOfCards.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
            deckOfCards.layer.borderWidth = (deckOfCards.frame.width)/30
            deckOfCards.image = UIImage(named: "blue_background")
        } else {
            closedCards.layer.cornerRadius = 0
            closedCards.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
            closedCards.layer.borderWidth = 0
            closedCards.setBackgroundImage(nil, for: .normal)
            
            deckOfCards.layer.cornerRadius = 0
            deckOfCards.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
            deckOfCards.layer.borderWidth = 0
            deckOfCards.image = nil
        }
    }
    
    func openedCardsUI (exist: Bool) {
        if exist == true {
            openedCards.isHidden = false
            openedCards.layer.cornerRadius = 9
            openedCards.layer.borderWidth = (openedCards.frame.width)/30
            openedCards.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        }
        else {
            openedCards.image = nil
            openedCards.backgroundColor = nil
            openedCards.layer.cornerRadius = 0
            openedCards.layer.borderWidth = 0
            openedCards.layer.borderColor = UIColor(white: 0, alpha: 0).cgColor
        }
    }
}
