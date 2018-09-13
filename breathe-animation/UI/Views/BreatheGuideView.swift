import UIKit

class BreatheGuideView: UIView, BreatheAnimatable, ProgressLayerDelegate {
    
    private lazy var progressLayer: ProgressLayer = {
        let progressLayer = ProgressLayer(delegate: self)
        progressLayer.frame = frame
        return progressLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layer.addSublayer(progressLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progressCallback: ((Float) -> Void) = { _ in }
    
    func performAnimation(animation: CAAnimation) {
        let progressAnimation = createProgressAnimation(duration: animation.duration)
        
        layer.add(animation, forKey: "animation")
        progressLayer.add(progressAnimation, forKey: "progressAnimation")
    }
    
    var animatableLayer: CALayer {
        return layer
    }
    
    func progressUpdated(progress: Float) {
        progressCallback(progress)
    }
    
    private func createProgressAnimation(duration: Double) -> CABasicAnimation {
        let progressAnimation = CABasicAnimation(keyPath: "progress")
        progressAnimation.duration = duration
        progressAnimation.fromValue = 0.0
        progressAnimation.toValue = 1.0
        progressAnimation.fillMode = kCAFillModeForwards
        
        return progressAnimation
    }
}

fileprivate protocol ProgressLayerDelegate: class {
    func progressUpdated(progress: Float)
}

fileprivate final class ProgressLayer: CALayer {
    @objc dynamic var progress: Float = 0
    
    weak var progressDelegate: ProgressLayerDelegate?

    override init(layer: Any) {
        super.init(layer: layer)
        
        if let layer = layer as? ProgressLayer {
            progress = layer.progress
            progressDelegate = layer.progressDelegate
        }
    }
    
    init(delegate: ProgressLayerDelegate) {
        super.init()
        progressDelegate = delegate
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "progress" {
            return true
        } else {
            return super.needsDisplay(forKey: key)
        }
    }
    
    override func draw(in ctx: CGContext) {
        if let delegate = progressDelegate {
            delegate.progressUpdated(progress: progress)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
