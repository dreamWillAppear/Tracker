import UIKit
import SnapKit

class StatisticsViewController: UIViewController {
    
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
        return view
    }()
    
    private lazy var noStatisticsImageView: UIImageView = {
        let view = UIImageView()
        view.image = .noStatistics
        return view
    }()
    
    private var noStatisticsLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    // MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        
        view.addSubview(mainLabel)
        view.addSubview(noStatisticsStackView)
 
        noStatisticsStackView.addArrangedSubview(noStatisticsImageView)
        noStatisticsStackView.addArrangedSubview(noStatisticsLabel)
        
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
        
        
    }
}

// MARK: - Types

// MARK: - Constants

// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods
