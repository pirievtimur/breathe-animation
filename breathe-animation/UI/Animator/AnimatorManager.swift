class AnimatorManager {
    private var animatorsChain: [Animator] = []
    private var completion: (() -> Void)? = nil
    
    init(animators: [Animator], completion: (() -> Void)? = nil) {
        self.completion = completion
        
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
