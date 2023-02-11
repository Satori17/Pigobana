//
//  CardsWorker.swift
//  Pigobana
//
//  Created by skhitaridze on 23.01.23.
//

import UIKit

protocol CardsWorkerProtocol {
    func getCards() -> [CardModel]
}

final class CardsWorker: CardsWorkerProtocol {
    
    //for testing
    private let cardsArray = [
        CardModel(name: "2C"),
        CardModel(name: "3C"),
        CardModel(name: "4C"),
        CardModel(name: "5C"),
        CardModel(name: "6C"),
        CardModel(name: "7C"),
        CardModel(name: "8C"),
        CardModel(name: "9C"),
        CardModel(name: "10C"),
        CardModel(name: "JC"),
        CardModel(name: "3H"),
        CardModel(name: "3S")
    ]
    
//            private let cardsArray = [
//                CardModel(name: "2C"),
//                CardModel(name: "2D"),
//                CardModel(name: "2H"),
//                CardModel(name: "2S"),
//                CardModel(name: "3C"),
//                CardModel(name: "3D"),
//                CardModel(name: "3H"),
//                CardModel(name: "3S"),
//                CardModel(name: "4C"),
//                CardModel(name: "4D"),
//                CardModel(name: "4H"),
//                CardModel(name: "4S"),
//                CardModel(name: "5C"),
//                CardModel(name: "5D"),
//                CardModel(name: "5H"),
//                CardModel(name: "5S"),
//                CardModel(name: "6C"),
//                CardModel(name: "6D"),
//                CardModel(name: "6H"),
//                CardModel(name: "6S"),
//                CardModel(name: "7C"),
//                CardModel(name: "7D"),
//                CardModel(name: "7H"),
//                CardModel(name: "7S"),
//                CardModel(name: "8C"),
//                CardModel(name: "8D"),
//                CardModel(name: "8H"),
//                CardModel(name: "8S"),
//                CardModel(name: "9C"),
//                CardModel(name: "9D"),
//                CardModel(name: "9H"),
//                CardModel(name: "9S"),
//                CardModel(name: "10C"),
//                CardModel(name: "10D"),
//                CardModel(name: "10H"),
//                CardModel(name: "10S"),
//                CardModel(name: "JC"),
//                CardModel(name: "JD"),
//                CardModel(name: "JH"),
//                CardModel(name: "JS"),
//                CardModel(name: "QC"),
//                CardModel(name: "QD"),
//                CardModel(name: "QH"),
//                CardModel(name: "QS"),
//                CardModel(name: "KC"),
//                CardModel(name: "KD"),
//                CardModel(name: "KH"),
//                CardModel(name: "KS"),
//                CardModel(name: "AC"),
//                CardModel(name: "AD"),
//                CardModel(name: "AH"),
//                CardModel(name: "AS")
//            ]
    
    func getCards() -> [CardModel] {
        cardsArray.shuffled()
    }
}
