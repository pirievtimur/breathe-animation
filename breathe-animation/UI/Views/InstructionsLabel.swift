import UIKit

class InstructionsLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .center
        textColor = .black
        font = UIFont.systemFont(ofSize: 16)
        numberOfLines = 2
    }
    
    func updatePhase(_ phase: BreathePhase, progress: Double) {
        let phaseName = phase.type.rawValue.uppercased()
        let seconds = phase.duration * Double(progress)
        
        text = "\(phaseName)\n \(seconds)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
