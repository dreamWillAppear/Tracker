import UIKit
import SnapKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let factory = StatisticsFactory.shared
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var noStatisticsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        view.isHidden = false
        return view
    }()
    
    private lazy var noStatisticsImageView: UIImageView = {
        let view = UIImageView()
        view.image = .noStatistics
        return view
    }()
    
    private lazy var noStatisticsLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var countersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var bestPeriod = StatisticsCounter(counter: factory.longestPerfectStreak, counterName: "Лучший период")
    private lazy var perfectDays = StatisticsCounter(counter: factory.perfectDaysCount, counterName: "Идеальные дни")
    private lazy var completedTrackers = StatisticsCounter(counter: factory.allRecordsCount, counterName: "Трекеров завершено")
    private lazy var averageCount = StatisticsCounter(counter: factory.averageValue, counterName: "Среднее значение")
    
    private lazy var counters = [bestPeriod, perfectDays, completedTrackers, averageCount]
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        factory.statisticsDidUpdated = { [weak self] in
            self?.updateStatistics()
        }
        
    }
    
    // MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerMainBackground
        
        mainScrollView.addSubview(countersStackView)
        
        [mainLabel,
         mainScrollView,
         noStatisticsStackView].forEach {
            view.addSubview($0)
        }
        
        [noStatisticsImageView,
         noStatisticsLabel].forEach {
            noStatisticsStackView.addArrangedSubview($0)
        }
        
        counters.forEach {
            $0.isHidden = $0.counter == 0
            countersStackView.addArrangedSubview($0)
        }
        
        setConstraints()
        checkPlaceholderVisibility()
    }
    
    private func setConstraints() {
        
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(-84)
            make.bottom.equalToSuperview().inset(50)
            make.width.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.width.equalTo(254)
            make.height.equalTo(41)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(88)
        }
        
        noStatisticsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        
        noStatisticsImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        countersStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(getCountersStackViewHeight()) //высотка вьюх + высота отсупов по макету
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func getCountersStackViewHeight() -> CGFloat {
        let visibleViews = countersStackView.visibleViewsCount()
        guard visibleViews  > 1 else { return 90 }
        
        return CGFloat((visibleViews * 90) + (12 * visibleViews - 1))
    }
    
    private func updateStatistics() {
        completedTrackers.counter = factory.allRecordsCount
        perfectDays.counter = factory.perfectDaysCount
        bestPeriod.counter = factory.longestPerfectStreak
        averageCount.counter = factory.averageValue
        checkPlaceholderVisibility()
    }
    
    private func checkPlaceholderVisibility() {
        let isAnyCounterVisible = counters.contains { $0.counter != 0 }
        noStatisticsStackView.isHidden = isAnyCounterVisible
        countersStackView.isHidden = !noStatisticsStackView.isHidden
        
        countersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        counters.forEach { counter in
            if counter.counter != 0 {
                counter.isHidden = false
                countersStackView.addArrangedSubview(counter)
            }
        }
        
        countersStackView.snp.updateConstraints { make in
            make.height.equalTo(getCountersStackViewHeight())
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}

extension UIStackView {
    func visibleViewsCount() -> Int {
        var visibleViewCount = 0
        self.arrangedSubviews.forEach {
            if !$0.isHidden {
                visibleViewCount += 1
            }
        }
        return visibleViewCount
    }
}
