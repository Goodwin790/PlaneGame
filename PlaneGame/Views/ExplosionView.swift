//
//  ExplosionView.swift
//  PlaneGame
//
//  Created by Сергей Киров on 17.06.2023.
//

import UIKit

final class ExplosionView: UIView {
    
    private var explosionImages = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImages()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addImages()
        setupView()
    }
    
    private func addImages() {
        for imageName in 1...15 {
            if let image = UIImage(named: "\(imageName)") {
                explosionImages.append(image)
                print(imageName)
            }
        }
    }
    
    private func setupView() {
        let explosionView = UIImageView(frame: frame)
        addSubview(explosionView)
        explosionView.animationImages = explosionImages
        explosionView.animationDuration = 0.3
        explosionView.animationRepeatCount = 0
        explosionView.startAnimating()
    }
    
}
