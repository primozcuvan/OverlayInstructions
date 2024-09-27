//
//  CutoutMaskView.swift
//  
//
//  Created by Primoz Cuvan on 15. 09. 24.
//

import SwiftUI

internal struct CutoutMaskView: View, Animatable {
    
    private var cutoutFrame: CGRect
    private var cornerRadius: CGFloat
    private var animationDuration: TimeInterval
    
    init(cutoutFrame: CGRect, cornerRadius: CGFloat, animationDuration: TimeInterval) {
        self.cutoutFrame = cutoutFrame
        self.cornerRadius = cornerRadius
        self.animationDuration = animationDuration
    }
    
    var body: some View {
        GeometryReader { geometry in
            let path = UIBezierPath(rect: geometry.frame(in: .local))
            let cutoutPath = UIBezierPath(roundedRect: cutoutFrame, cornerRadius: cornerRadius)
            path.append(cutoutPath.reversing())
            
            return Path(path.cgPath)
        }
        .animation(.easeInOut(duration: animationDuration), value: cutoutFrame)
    }
    
    /// Animatable allows SwiftUI to animate the changes when cutoutFrame changes.
    /// AnimatableData is a computed property that returns an animatable version of cutoutFrame.
    /// This uses AnimatablePair to animate the individual components of the CGRect (i.e., origin.x, origin.y, width, and height).
    /// SwiftUI interpolates the values of the AnimatableData, which smoothly transitions between different sizes and positions of cutoutFrame.
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(
                AnimatablePair(cutoutFrame.origin.x, cutoutFrame.origin.y),
                AnimatablePair(cutoutFrame.size.width, cutoutFrame.size.height)
            )
        }
        set {
            cutoutFrame = CGRect(
                x: newValue.first.first,
                y: newValue.first.second,
                width: newValue.second.first,
                height: newValue.second.second
            )
        }
    }
}
