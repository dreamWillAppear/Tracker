import UIKit

extension UINavigationController {
    func pushViewControllerFromBottom(_ viewController: UIViewController, animated: Bool) {
        if animated {
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            self.view.layer.add(transition, forKey: nil)
        }
        self.pushViewController(viewController, animated: false)
    }
}
