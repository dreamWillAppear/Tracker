import UIKit
import SnapKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var bluePageText: String = {
        "Отслеживайте только то, что хотите"
    }()
    
    private lazy var redPageText: String = {
        "Даже если это не литры воды и йога"
    }()
    
    private lazy var pages = [
        OnboardingPageViewController(backgroundImage: .onboardingBlueBackground, labelText: bluePageText),
        OnboardingPageViewController(backgroundImage: .onboardingRedBackground, labelText: redPageText)
    ]
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .trackerBlack
        pageControl.pageIndicatorTintColor = .trackerGray
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        delegate = self
        
        setUI()
        
        view.backgroundColor = .trackerWhite
    }
    
    private func setUI() {
        
        
        if pages.first != nil {
            setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        }
        
        [pageControl].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(6)
            make.bottom.equalToSuperview().inset(168)
        }
        
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let onboardingViewController = viewController as? OnboardingPageViewController,
              let viewControllerIndex = pages.firstIndex(of: onboardingViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let onboardingViewController = viewController as? OnboardingPageViewController,
              let viewControllerIndex = pages.firstIndex(of: onboardingViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
