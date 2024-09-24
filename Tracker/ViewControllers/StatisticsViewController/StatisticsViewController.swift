import UIKit
import SnapKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var noStatisticsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        view.isHidden = true
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
    
    private lazy var bestPeriod = StatisticsCounter(counter: 123123, counterName: "Лучший период")
    private lazy var perfectDays = StatisticsCounter(counter: 23, counterName: "Идеальные дни")
    private lazy var completedTrackers = StatisticsCounter(counter: 1, counterName: "Трекеров завершено")
    private lazy var averageCount = StatisticsCounter(counter: 2333333945999999955, counterName: "Среднее значение")
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        
        [mainLabel,
         countersStackView,
         noStatisticsStackView].forEach {
            view.addSubview($0)
        }
        
        [noStatisticsImageView,
         noStatisticsLabel].forEach {
            noStatisticsStackView.addArrangedSubview($0)
        }
        
        [bestPeriod, perfectDays, completedTrackers, averageCount].forEach {
            countersStackView.addArrangedSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
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
            make.top.equalTo(mainLabel.snp.bottom).inset(-84)
            make.height.equalTo(getCountersStackViewHeight()) //высотка вьюх + высота отсупов по макету
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func getCountersStackViewHeight() -> CGFloat {
        let visibleViews = countersStackView.visibleViewsCount()
        guard visibleViews  > 1 else { return 90 }
        
        return CGFloat((visibleViews * 90) + (12 * visibleViews - 1)) 
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
