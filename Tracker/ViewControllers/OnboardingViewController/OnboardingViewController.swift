import UIKit
import SnapKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pages = [UIViewController]()
    
    private lazy var  bluePage: UIViewController = {
        let vc = UIViewController()
        
        let imageView = UIImageView(image: UIImage(resource: .onboardingBlueBackgraund))
        imageView.contentMode = .scaleAspectFill
        vc.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = "Отслеживайте только то, что хотите"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .trackerBlack
        vc.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(340)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        return vc
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .trackerBlack
        pageControl.pageIndicatorTintColor = .trackerGray
        return pageControl
    }()
    
    private lazy var redPage: UIViewController = {
        let vc = UIViewController()
        
        let imageView = UIImageView(image: UIImage(resource: .onboardingRedBackground))
        imageView.contentMode = .scaleAspectFill
        vc.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = "Даже если это не литры воды и йога"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .trackerBlack
        vc.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(340)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        return vc
    }()
    
    private lazy var amazingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.tintColor = .trackerWhite
        button.setTitle("Вот это технологии!", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapThatAmazingButton),
            for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        delegate = self
        
        setUI()
        
        view.backgroundColor = .trackerWhite
    }
    
    private func setUI() {
        [bluePage, redPage].forEach {
            pages.append($0)
        }
        
        if pages.first != nil {
            setViewControllers([bluePage], direction: .forward, animated: true, completion: nil)
        }
        
        [pageControl, amazingButton].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        amazingButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(84)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(6)
            make.bottom.equalTo(amazingButton.snp.top).inset(-24)
        }
        
    }
    
    @objc private func didTapThatAmazingButton() {
        self.dismiss(animated: true)
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
