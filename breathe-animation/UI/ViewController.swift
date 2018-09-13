import UIKit
import Foundation

class ViewController: UIViewController {
    
    private lazy var guideView = createGuideView()
    private lazy var animationManager = createAnimationManager()
    private lazy var instructionsLabel = createInstructionsLabel()
    
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
        view.addSubview(instructionsLabel)
    }
}

private extension ViewController {
    func createGuideView() -> BreatheGuideView {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        let guideView = BreatheGuideView(frame: rect)
        guideView.center = view.center
        guideView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1)
        
        return guideView
    }
    
    func createInstructionsLabel() -> InstructionsLabel {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let label = InstructionsLabel(frame: frame)
        label.center = guideView.center
        
        return label
    }
    
    func createAnimationManager() -> AnimatorManager {
        let phases = BreathePhasesProvider().phases() ?? []
        
        let completion = { [view = guideView] in
            view.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1)
        }
        
        let progress = { [instructionsLabel] (phase: BreathePhase, progress: Float) in
            instructionsLabel.updatePhase(phase, progress: Double(progress))
        }
        
        return AnimatorManager(phases: phases,
                               animatableView: guideView,
                               completion: completion,
                               progress: progress)
    }
}
