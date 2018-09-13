import UIKit

protocol BreatheAnimatableView {
    var scalableView: UIView { get }
    
    func updateTitle(type: BreatheType, seconds: Double)
}

protocol Animator: class {
    var completionHandler: (() -> Void)? { get set }
    func startAnimating()
}

class BreatheAnimator: NSObject, Animator {
    
    var completionHandler: (() -> Void)?
    
    private let animatableView: BreatheAnimatableView
    private let breathePhase: BreathePhase
    
    private var animation: CABasicAnimation?
    private var toValue: CATransform3D?
    
    init(animatableView: BreatheAnimatableView,
         breathePhase: BreathePhase) {
        self.animatableView = animatableView
        self.breathePhase = breathePhase
    }
    
    func startAnimating() {
        animation = CABasicAnimation(keyPath: "transform")
        animation?.duration = breathePhase.duration
        animation?.delegate = self
        animation?.beginTime = CACurrentMediaTime() + 1
        animation?.fromValue = animatableView.scalableView.layer.transform

        switch breathePhase.type {
        case .inhale:
            toValue = CATransform3DIdentity
        case .exhale:
            toValue = CATransform3DMakeScale(0.5, 0.5, 1)
        case .hold:
            toValue = animatableView.scalableView.layer.transform
        }
        
        animation?.toValue = toValue
        
        animatableView.scalableView.layer.add(animation!, forKey: "some")
    }
}

extension BreatheAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transform = toValue, let handler = completionHandler {
            animatableView.scalableView.layer.transform = transform
            handler()
        }
    }
}
