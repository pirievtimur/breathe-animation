class AnimatorManager {
    
    private var animatorsChain: [Animator] = []
    private var completion: (() -> Void)? = nil
    
    
    init(phases: [BreathePhase],
         animatableView: BreatheAnimatable,
         completion: (() -> Void)? = nil,
         progress: ((BreathePhase, Float) -> Void)? = nil) {
        self.completion = completion
        
        let animators = phases.map { BreatheAnimator(animatableView: animatableView,
                                                     breathePhase: $0,
                                                     progress: progress) }
        
        animators.forEach { [weak self] animator in
            if let last = self?.animatorsChain.last {
                last.completionHandler = { animator.startAnimating() }
            }
            
            self?.animatorsChain.append(animator)
        }
        
        if let last = animatorsChain.last {
            last.completionHandler = { [weak self] in
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
            animator.startAnimating()
        }
    }
}
