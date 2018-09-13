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
    private lazy var remainingTimeLabel = createRemainingTimeLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    @objc func startBreathing() {
        updateUI(state: .breathing)
        guideView.prepareToAnimate { [weak self] in
            self?.animationManager.startAnimations()
        }
    }
    
    private func updateUI(state: State) {
        switch state {
        case .initial:
            startBreatheButton.isHidden = false
            instructionsLabel.isHidden = true
            remainingTimeLabel.isHidden = true
        case .breathing:
            startBreatheButton.isHidden = true
            instructionsLabel.isHidden = false
            remainingTimeLabel.isHidden = false
        }
    }
    
    private func setupSubviews() {
        view.addSubview(guideView)
        view.addSubview(instructionsLabel)
        view.addSubview(startBreatheButton)
        view.addSubview(remainingTimeLabel)
        
        updateUI(state: .initial)
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
    
    func createRemainingTimeLabel() -> RemainingTimeLabel {
        let label = RemainingTimeLabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - 150)
        
        return label
    }
    
    func createAnimationManager() -> BreatheAnimationManager {
        let phases = BreathePhasesProvider().phases() ?? []
        
        let completion = { [guideView] in
            guideView.restoreInitialState(completion: { [weak self] in self?.updateUI(state: .initial) })
        }
        
        let progress = { [instructionsLabel] (phase: BreathePhase, progress: Float) in
            instructionsLabel.updatePhase(phase, progress: progress)
        }
        
        let remainingTime = { [remainingTimeLabel] (seconds: Int) in
            remainingTimeLabel.update(seconds: seconds)
        }
        
        return BreatheAnimationManager(phases: phases,
                                       animatableView: guideView,
                                       completion: completion,
                                       stepProgress: progress,
                                       remainingTime: remainingTime)
    }
}
