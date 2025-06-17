//
//  UIImageView+Animations.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 17/06/2025.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
