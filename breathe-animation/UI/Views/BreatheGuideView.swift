import UIKit

class BreatheGuideView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Test"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = .yellow
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.center = center
    }
}

extension BreatheGuideView: BreatheAnimatableView {
    var scalableView: UIView {
        return self
    }
    
    func updateTitle(type: BreatheType, seconds: Double) {
        titleLabel.text = type.rawValue
    }
}
