import UIKit

extension UIView {
    
    func addGradientBorder(width: CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        //по rgb из фигмы
        gradientLayer.colors = [
            UIColor(red: 0.0, green: 0.482, blue: 0.98, alpha: 1.0).cgColor,
            UIColor(red: 0.275, green: 0.902, blue: 0.616, alpha: 1.0).cgColor,
            UIColor(red: 0.992, green: 0.298, blue: 0.286, alpha: 1.0).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.frame = bounds
        
        let borderLayer = CAShapeLayer()
        let insetBounds = bounds.insetBy(dx: width, dy: width)
        borderLayer.path = UIBezierPath(roundedRect: insetBounds, cornerRadius: layer.cornerRadius).cgPath
        borderLayer.lineWidth = width
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = borderLayer
        
        layer.addSublayer(gradientLayer)
    }
    
}
