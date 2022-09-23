//
//  GameOverVC.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 20.07.21.
//

import UIKit


protocol NewGameDelegate: AnyObject {
    func startNewGame()
}

class GameOverVC: UIViewController {
    
    @IBOutlet weak var pressBtn: UIButton!
    
    weak var delegate: NewGameDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIchanges()
    }
    
    
    @IBAction func playAgainBtn(_ sender: UIButton) {
        delegate.startNewGame()
    }
    
    func UIchanges() {
        pressBtn.layer.cornerRadius = 25
        pressBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        pressBtn.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        pressBtn.layer.shadowOpacity = 1.0
    }
}
