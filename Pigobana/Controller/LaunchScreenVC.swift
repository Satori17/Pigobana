//
//  LaunchScreenVC.swift
//  Pigobana
//
//  Created by Saba Khitaridze on 11.01.22.
//

import UIKit

class LaunchScreenVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchingUI()
    }
    
    func launchingUI() {
        progressView.setProgress(2.5, animated: true)
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.cornerRadius = 15
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7, execute: {
            UIView.transition(with: self.playButton, duration: 0.6, options: .transitionCrossDissolve, animations: { self.playButton.isHidden = false }, completion: nil)
        })
        
    }
    
    //MARK: - IBAction
    @IBAction func playButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlayVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
