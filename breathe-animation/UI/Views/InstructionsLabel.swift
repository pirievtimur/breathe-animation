import UIKit
import Foundation

class InstructionsLabel: UILabel {
    
    var previousProgressValue: Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .center
        textColor = .black
        font = UIFont.systemFont(ofSize: 16)
        numberOfLines = 2
    }
    
    func updatePhase(_ phase: BreathePhase, progress: Float) {
        if previousProgressValue == progress { return }
        
        let phaseName = phase.type.rawValue.uppercased()
        let seconds = Int(round(abs(Float(phase.duration) * progress - Float(phase.duration))))
        let timeString = minutesSecondsString(seconds: seconds)
        
        text = "\(phaseName)\n\(timeString)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
