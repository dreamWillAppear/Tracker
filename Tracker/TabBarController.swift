import UIKit

final class TabBarController: UITabBarController {
    let borderColor =  UIColor.trackerTabBarBorder.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .trackerMainBackground
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = borderColor
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticsViewController = StatisticsViewController()
        configureTabBarButtons(trackersViewControler: trackersViewController, and: statisticsViewController)
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { //без этого метода почему-то  borderColor не меняется "на лету", видимо потому что cgColor
        super.traitCollectionDidChange(previousTraitCollection)
        tabBar.layer.borderColor = UIColor.trackerTabBarBorder.cgColor
    }

    private func configureTabBarButtons(trackersViewControler: UIViewController, and statisticsViewController: UIViewController) {
        trackersViewControler.tabBarItem = UITabBarItem(
            title: Localizable.tabBarTrackersButton.localized(),
            image: UIImage(systemName: "record.circle.fill")?
                .withTintColor(.trackerGray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: Localizable.tabBarStatisticsButton.localized(),
            image: UIImage(systemName: "hare.fill")?
                .withTintColor(.trackerGray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "hare.fill")
        )
    }
    
}
