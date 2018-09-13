import UIKit
import Foundation

class RemainingTimeLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .center
        textColor = .black
        font = UIFont.systemFont(ofSize: 16)
        numberOfLines = 2
    }
    
    func update(seconds: Int) {
        let remainingTimeString = minutesSecondsString(seconds: seconds)
        
        text = "Remaining\n\(remainingTimeString)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
