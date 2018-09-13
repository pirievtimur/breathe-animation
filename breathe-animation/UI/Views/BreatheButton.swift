import UIKit

class BreatheButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        setTitle("TAP HERE\nTO BREATHE", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
