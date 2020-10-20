//
//  AnimationFactory.swift
//  Weather
//
//  Created by Eddy R on 16/09/2020.
//  Copyright © 2020 Eddy R. All rights reserved.
//

import UIKit

class AnimationFactoryWorker {
    
    /// Anime an UIImageView with Constraint
    /// - Parameters:
    ///   - mainView: main view where is executed the animation, need to update the view with "layoutIfNeeded" Method
    ///   - view: Object to animated
    ///   - constant: constraint from SB
    /// - Returns: UIViewPropertyAnimator
    static func slideUpToTheRight(mainView: UIView? ,view: UIView, constant: NSLayoutConstraint) -> UIViewPropertyAnimator {
        //set objet animation
        let slide = UIViewPropertyAnimator(duration: 1, curve: .easeOut)
        
        // add an animation
        slide.addAnimations ({
            view.alpha = 1
            constant.constant = 0
            if let mainview = mainView {
                mainview.layoutIfNeeded() // must to stay at  the end to force updating
            }
        }, delayFactor: 0)
        // maybe a callback if needed
        return slide
    }
    
    
    static func scaleUpandDown(view: UIView) {
        UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseInOut ,.repeat, .autoreverse], animations: {
            view.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: nil)
    }
}

