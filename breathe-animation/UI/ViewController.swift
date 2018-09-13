import UIKit
import Foundation

class ViewController: UIViewController {
    
    private lazy var guideView = createGuideView()
    private lazy var animationManager = createAnimationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationManager.startAnimations()
    }
    
    private func setupSubviews() {
        view.addSubview(guideView)
    }
    
    private func createGuideView() -> BreatheGuideView {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        let guideView = BreatheGuideView(frame: rect)
        guideView.center = view.center
        guideView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1)
        
        return guideView
    }
    
    private func createAnimationManager() -> AnimatorManager {
        let phases = BreathePhasesProvider().phases() ?? []
        let animators = phases.map { BreatheAnimator(animatableView: guideView, breathePhase: $0) }
        return AnimatorManager(animators: animators) { [view = guideView] in
            view.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1)
        }
    }
}
