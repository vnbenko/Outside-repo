import UIKit

extension UIView {
    func setRadiusWithShadow(radius: CGFloat? = nil, color: CGColor? = nil, position: CGSize? = nil, shadowVolume: CGFloat = 15, opacity: Float = 0.7) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = color ?? UIColor.black.cgColor
        self.layer.shadowOffset = position ?? CGSize(width: 0, height: 0)
        self.layer.shadowRadius = shadowVolume
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    func roundCorners(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
    }
    
}
