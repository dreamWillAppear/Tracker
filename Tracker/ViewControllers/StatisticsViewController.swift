import UIKit
import SnapKit

class StatisticsViewController: UIViewController {

    // MARK: - Private Properties
    
    private var mainLabel = UILabel()
    private var noStatisticsImageView = UIImageView()
    private var noStatisticsLabel = UILabel()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setUI()
    }
    
    // MARK: - Private Methods
    
    private func setUI() {
        view.backgroundColor = .trackerWhite
        
        configureMainLabel()
        configureNoStatisticsImageAndText()
    }
    
    private func configureMainLabel() {
        mainLabel.text = "Статистика"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 34)
        mainLabel.textAlignment = .left
        view.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.width.equalTo(254)
            make.height.equalTo(41)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(88)
        }
    }
    
    private func configureNoStatisticsImageAndText() {
        noStatisticsImageView.image = .noStatistics
        view.addSubview(noStatisticsImageView)
        
        noStatisticsImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.centerY.equalToSuperview()
        }
        
       noStatisticsLabel.text = "Анализировать пока нечего"
       noStatisticsLabel.font = .systemFont(ofSize: 12)
        noStatisticsLabel.textAlignment = .center
        view.addSubview(noStatisticsLabel)
        
       noStatisticsLabel.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(18)
           make.top.equalTo(noStatisticsImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
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
