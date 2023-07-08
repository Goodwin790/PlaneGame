//
//  MainScreenViewController.swift
//  PlainGame
//
//  Created by Сергей Киров on 15.06.2023.
//

import UIKit

private extension CGFloat {
    static let buttonSide = 50.0
    static let buttonWidth = 300.0
    static let buttonCornerRadius = 10.0
}

class MainScreenViewController: UIViewController {
    
    private var startGameButton: UIButton?
    private var settingsButton: UIButton?
    private var recordsButton: UIButton?
    private var buttonsStack: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupButtons()
    }
    
    @objc private func recordsButtonIsTapped() {
        let recordsVC = RecordTableViewController()
        navigationController?.present(recordsVC, animated: true)
    }
    
    @objc private func settingsButtonIsPressed() {
        let settingsVC = SettingsScreenViewController()
        navigationController?.present(settingsVC, animated: true)
    }
    
    @objc private func startGameIsPressed() {
        let gameVC = GameplayViewController()
        gameVC.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func setupButtons() {
        let buttonX = (view.frame.width / 2) - (.buttonWidth / 2)
        startGameButton = UIButton()
        if let startGameButton = startGameButton {
            startGameButton.frame = CGRect(x: buttonX, y: view.frame.height - .buttonWidth, width: .buttonWidth, height: .buttonSide)
            startGameButton.setTitle("Start game", for: .normal)
            startGameButton.setTitleColor(.black, for: .normal)
            startGameButton.backgroundColor = .green
            startGameButton.layer.cornerRadius = .buttonCornerRadius
            startGameButton.addTarget(self, action: #selector(startGameIsPressed), for: .touchUpInside)
            view.addSubview(startGameButton)
        }
        
        settingsButton = UIButton()
        if let settingsButton = settingsButton {
            settingsButton.frame = CGRect(x: view.frame.maxX - .buttonSide,
                                          y: .buttonSide * 2 ,
                                          width: .buttonSide,
                                          height: .buttonSide)
            settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
            settingsButton.addTarget(self, action: #selector(settingsButtonIsPressed), for: .touchUpInside)
            view.addSubview(settingsButton)

        }
        
        recordsButton = UIButton()
        if let recordsButton = recordsButton {
            recordsButton.frame = CGRect(x: view.frame.minX,
                                          y: .buttonSide * 2 ,
                                          width: .buttonSide,
                                          height: .buttonSide)
            recordsButton.setImage(UIImage(systemName: "dumbbell"), for: .normal)
            recordsButton.addTarget(self, action: #selector(recordsButtonIsTapped), for: .touchUpInside)
            view.addSubview(recordsButton)
        }
        
    }
    
    func setBackground() {
        let backgroundImage = UIImage(named: "MainBackground")
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = backgroundImage
        backgroundView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundView, at: 0)
    }

}
