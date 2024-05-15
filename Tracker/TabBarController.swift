import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        configureTabBarButtons(trackersViewControler: trackersViewController, and: statisticsViewController)
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func configureTabBarButtons(trackersViewControler: UIViewController, and statisticsViewController: UIViewController) {
        trackersViewControler.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle"),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare"),
            selectedImage: UIImage(systemName: "hare.fill")
        )

    }
    
    
    
}
