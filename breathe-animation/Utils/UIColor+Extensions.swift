import UIKit

extension UIColor {
    convenience init(hex: String) {
        let set = CharacterSet(charactersIn: "#").inverted
        let hexColorString = String(hex.unicodeScalars.filter { set.contains($0) })
        
        let scanner = Scanner(string: hexColorString)
        scanner.scanLocation = 0
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let redFloat = CGFloat((rgb & 0xff0000) >> 16)
        let greenFloat = CGFloat((rgb & 0xff00) >> 8)
        let blueFloat = CGFloat(rgb & 0xff)
        
        self.init(red: redFloat / 0xff,
                  green: greenFloat / 0xff,
                  blue: blueFloat / 0xff,
                  alpha: 1)
    }
}
