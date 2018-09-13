import Foundation

class BreatheAnimationManager {
    
    private var animatorsChain: [Animator] = []
    private var completion: (() -> Void)? = nil
    private var remainingTime: ((Int) -> Void)? = nil
    
    private var timer: Timer?
    private var animationTime: Int = 0
    private var countdownTime: Int = 0
    
    init(phases: [BreathePhase],
         animatableView: BreatheAnimatable,
         completion: (() -> Void)? = nil,
         stepProgress: ((BreathePhase, Float) -> Void)? = nil,
         remainingTime: ((Int) -> Void)? = nil) {
        self.completion = completion
        self.remainingTime = remainingTime

        phases.forEach { [unowned self] phase in
            self.animationTime += Int(phase.duration)
            let animator = BreatheAnimator(animatableView: animatableView,
                                   breathePhase: phase,
                                   progress: stepProgress)
            
            if let last = self.animatorsChain.last {
                last.completionHandler = { animator.startAnimating() }
            }
            
            self.animatorsChain.append(animator)
        }

        if let last = animatorsChain.last {
            last.completionHandler = { [weak self] in
                self?.timer?.invalidate()
                guard let completion = self?.completion else { return }
                completion()
            }
        }
    }
    
    func startAnimations() {
        if animatorsChain.isEmpty {
            guard let completion = completion else { return }
            completion()
        } else {
            guard let animator = animatorsChain.first else { return }
            startTimer()
            animator.startAnimating()
        }
    }
    
    private func startTimer() {
        countdownTime = animationTime
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil, repeats: true)
    }
    
    @objc private func tick() {
        countdownTime -= 1
        guard let handler = remainingTime else { return }
        handler(countdownTime)
    }
}
