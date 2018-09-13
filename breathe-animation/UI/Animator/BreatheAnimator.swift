import UIKit

protocol BreatheAnimatable: class {
    func performAnimation(animation: CAAnimation)
    var animatableLayer: CALayer { get }
    var progressCallback: ((Float) -> Void) { get set }
}

protocol Animator: class {
    var completionHandler: (() -> Void)? { get set }
    func startAnimating()
}

class BreatheAnimator: NSObject, Animator {
    
    var completionHandler: (() -> Void)?
    var animationProgress: ((BreathePhase, Float) -> Void)?
    
    private weak var animatableView: BreatheAnimatable?
    private let breathePhase: BreathePhase

    private var animation: CABasicAnimation?
    private var toValue: CATransform3D?
    
    init(animatableView: BreatheAnimatable,
         breathePhase: BreathePhase,
         progress: ((BreathePhase, Float) -> Void)? = nil) {
        self.animatableView = animatableView
        self.breathePhase = breathePhase
        self.animationProgress = progress
    }
    
    func startAnimating() {
        animatableView?.progressCallback = { [breathePhase, animationProgress, animatableView] progressValue in
            guard let progress = animationProgress else { return }
            
            
            if progressValue == 1.0, let value = self.toValue {
                animatableView?.animatableLayer.transform = value
            }
            
            progress(breathePhase, progressValue)
        }
        
        animation = CABasicAnimation(keyPath: "transform")
        animation?.duration = breathePhase.duration
        animation?.delegate = self
        animation?.fromValue = animatableView?.animatableLayer.transform

        switch breathePhase.type {
        case .inhale:
            toValue = CATransform3DIdentity
        case .exhale:
            toValue = CATransform3DMakeScale(0.5, 0.5, 1)
        case .hold:
            toValue = animatableView?.animatableLayer.transform
        }

        animation?.toValue = toValue
        animatableView?.performAnimation(animation: animation!)
    }
}

extension BreatheAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transform = toValue, let handler = completionHandler {
            animatableView?.animatableLayer.transform = transform
            handler()
        }
    }
}
