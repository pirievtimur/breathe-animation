import UIKit
import Foundation


class ViewController: UIViewController {
    
    enum State {
        case initial
        case breathing
    }
    
    private lazy var guideView = createGuideView()
    private lazy var animationManager = createAnimationManager()
    private lazy var instructionsLabel = createInstructionsLabel()
    private lazy var startBreatheButton = createButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    @objc func startBreathing() {
        updateUI(state: .breathing)
        guideView.prepareToAnimate { [animationManager] in
            animationManager.startAnimations()
        }
    }
    
    private func updateUI(state: State) {
        switch state {
        case .initial:
            startBreatheButton.isHidden = false
            instructionsLabel.isHidden = true
        case .breathing:
            startBreatheButton.isHidden = true
            instructionsLabel.isHidden = false
        }
    }
    
    private func setupSubviews() {
        view.addSubview(guideView)
        view.addSubview(instructionsLabel)
        instructionsLabel.isHidden = true
        view.addSubview(startBreatheButton)
    }
}

private extension ViewController {
    func createGuideView() -> BreatheGuideView {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        let guideView = BreatheGuideView(frame: rect)
        guideView.center = view.center
        
        return guideView
    }
    
    func createInstructionsLabel() -> InstructionsLabel {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let label = InstructionsLabel(frame: frame)
        label.center = guideView.center
        
        return label
    }
    
    func createButton() -> UIButton {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let button = BreatheButton(frame: frame)
        button.center = guideView.center
        button.addTarget(self, action: #selector(startBreathing), for: .touchUpInside)
        
        return button
    }
    
    func createAnimationManager() -> AnimatorManager {
        let phases = BreathePhasesProvider().phases() ?? []
        
        let completion = { [guideView] in
            guideView.restoreInitialState(completion: { [weak self] in self?.updateUI(state: .initial) })
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
