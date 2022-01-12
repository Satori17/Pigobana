//
//  PlayVC.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 12.07.21.
//

import UIKit


class PlayVC: UIViewController {
    
    
    //MARK: - IBOutlets
    
    //opened and closed cards
    @IBOutlet weak var openedCards: UIImageView!
    @IBOutlet weak var closedCards: UIButton!
    @IBOutlet weak var deckOfCards: UIImageView!
    //Collection views
    @IBOutlet weak var player1CardCollectionView: UICollectionView!
    @IBOutlet weak var player2CardCollectionView: UICollectionView!
    //card hider views
    @IBOutlet weak var hideCardsView: UIView!
    @IBOutlet weak var hideCards2View: UIView!
    //player card quantities
    @IBOutlet weak var player1CardAmount: UILabel!
    @IBOutlet weak var player2CardAmount: UILabel!
    
    
    
    //MARK: - Let
    let layout = UICollectionViewFlowLayout()
    let gradientMaskLayer = CAGradientLayer()
    let gradientMaskLayer2 = CAGradientLayer()
    
    //MARK: - Vars
    
    //determining first and second player
    var playerController = 0
    var cardCounter = 0
    var cardsData = CardsData()
    // Received cards array
    var player1Cards = [CardModel]()
    var player2Cards = [CardModel]()
    // Received cards holder
    var cardHolder: [CardModel] = []
    //Cards Data
    var cardsArray = [CardModel(name: "2C"),
                      CardModel(name: "2D"),
                      CardModel(name: "2H"),
                      CardModel(name: "2S"),
                      CardModel(name: "3C"),
                      CardModel(name: "3D"),
                      CardModel(name: "3H"),
                      CardModel(name: "3S"),
                      CardModel(name: "4C"),
                      CardModel(name: "4D"),
                      CardModel(name: "4H"),
                      CardModel(name: "4S"),
                      CardModel(name: "5C"),
                      CardModel(name: "5D"),
                      CardModel(name: "5H"),
                      CardModel(name: "5S"),
                      CardModel(name: "6C"),
                      CardModel(name: "6D"),
                      CardModel(name: "6H"),
                      CardModel(name: "6S"),
                      CardModel(name: "7C"),
                      CardModel(name: "7D"),
                      CardModel(name: "7H"),
                      CardModel(name: "7S"),
                      CardModel(name: "8C"),
                      CardModel(name: "8D"),
                      CardModel(name: "8H"),
                      CardModel(name: "8S"),
                      CardModel(name: "9C"),
                      CardModel(name: "9D"),
                      CardModel(name: "9H"),
                      CardModel(name: "9S"),
                      CardModel(name: "10C"),
                      CardModel(name: "10D"),
                      CardModel(name: "10H"),
                      CardModel(name: "10S"),
                      CardModel(name: "JC"),
                      CardModel(name: "JD"),
                      CardModel(name: "JH"),
                      CardModel(name: "JS"),
                      CardModel(name: "QC"),
                      CardModel(name: "QD"),
                      CardModel(name: "QH"),
                      CardModel(name: "QS"),
                      CardModel(name: "KC"),
                      CardModel(name: "KD"),
                      CardModel(name: "KH"),
                      CardModel(name: "KS"),
                      CardModel(name: "AC"),
                      CardModel(name: "AD"),
                      CardModel(name: "AH"),
                      CardModel(name: "AS")
    ]
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        afterLaunchUI()
        //notification()
        cardsArray.shuffle()
        cardsData.defineCardType(&cardsArray)
        player1CardCollectionView.isHidden = true
        player2CardCollectionView.isHidden = true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
    
    //MARK: - IBAction
    @IBAction func closedCardButton(_ sender: UIButton) {
        //logic
        controlPlayersAndCards()
       
      //navigation to Game over VC
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameOverVC = myStoryboard.instantiateViewController(withIdentifier: "GameOverVC") as! GameOverVC
        gameOverVC.delegate = self
        gameOverVC.modalPresentationStyle = .fullScreen
        
        if cardCounter == 52 {
            closedCardsUI(exist: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.present(gameOverVC, animated: true, completion: { self.cardCounter = 0 })
            }
        }
    }
}


//MARK: - Extensions


extension PlayVC: NewGame {
    func startNewGame() {
        self.dismiss(animated: true, completion: nil)
        player1CardCollectionView.isHidden = true
        player2CardCollectionView.isHidden = true
        hideCardsView.isHidden = true
        hideCards2View.isHidden = true
        player1Cards = []
        player2Cards = []
        cardHolder = []
        cardsArray.shuffle()
        // for starting a new game, we have to shuffle cards, as usual. also, this code prevents starting a new game if player decides to shuffle cards during playing.
        if (closedCards.backgroundImage(for: .normal) != nil) == false {
            openedCardsUI(exist: false)
            closedCardsUI(exist: true)
        }
    }
}

/*
 TODO list:
 
 1. hiding and reappearing player cards ✅
 2. motions when taking/returning cards
 3. launchscreen should be displayed more time✅
 4. bluetooth support to play with another iphone
 5. ability to play with computer
 6. to show shaking notification only first time and only once.
 7.  add several screens: 1) launch screen✅  2) history of pigobana  3) game instructions  4) notification of shuffling cards.
 8. remove some objc noises in console
 9. resolve memory leak issue
 10. create animation of card flipping from closed cards to opened cards✅
 11. count player card quantities and show them ✅
 12. hide card hiders when game is starting from beginning✅
 13. add testing
 14. progress bar when launching✅
 */
