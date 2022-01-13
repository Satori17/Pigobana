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
    
    
    //MARK: - IBAction
    @IBAction func playButtonPressed(_ sender: UIButton) {
        progressView.isHidden = false
        progressView.setProgress(2.5, animated: true)
        //fade out of button
        UIView.animate(withDuration: 0.4, animations: {
            self.playButton.alpha = 0
        })
        //transition to PlayVC
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayVC")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    func launchingUI() {
        playButton.layer.borderWidth = 0.5
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.cornerRadius = 15
        playButton.layer.shadowRadius = 10
        playButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        playButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        playButton.layer.shadowOpacity = 0.8
    }
}
