import UIKit

enum BreatheType: String, Codable {
    case inhale
    case exhale
    case hold
}

struct BreathePhase: Codable {
    var type: BreatheType
    var duration: Double
    var color: String
    
    var fillColor: UIColor {
        return UIColor(hex: color)
    }
}
