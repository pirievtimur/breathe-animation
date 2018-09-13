import UIKit
import Foundation

class InstructionsLabel: UILabel {
    
    var previousProgressValue: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .center
        textColor = .black
        font = UIFont.systemFont(ofSize: 16)
        numberOfLines = 2
    }
    
    func updatePhase(_ phase: BreathePhase, progress: Double) {
        if previousProgressValue == progress { return }
        
        let phaseName = phase.type.rawValue.uppercased()
        let seconds = Int(round(abs(phase.duration * Double(progress) - phase.duration)))
        let (m,s) = secondsToMinutesSeconds(seconds: seconds)
        let minutesString = convertValueToTimeRepresentation(value: m)
        let secondsString = convertValueToTimeRepresentation(value: s)

        text = "\(phaseName)\n\(minutesString + ":" + secondsString)"
    }
    
    func convertValueToTimeRepresentation(value: Int) -> String {
        let string = String(value)
        return string.count > 1 ? string : "0" + string
    }
    
    func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
