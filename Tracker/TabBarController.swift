import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .trackerWhite
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.trackerLightGray.cgColor
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticsViewController = StatisticsViewController()
        configureTabBarButtons(trackersViewControler: trackersViewController, and: statisticsViewController)
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func configureTabBarButtons(trackersViewControler: UIViewController, and statisticsViewController: UIViewController) {
        trackersViewControler.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill")?.withTintColor(.trackerGray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill")?.withTintColor(.trackerGray, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "hare.fill")
        )

    }
    
    
    
}
