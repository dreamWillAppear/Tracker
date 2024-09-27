import UIKit
import SnapKit

final class TrackerButton: UIButton {
 
    //MARK: - Private Properties
    
    private var mainLabel: UILabel?
    private var supplementaryLabel: UILabel?
    
    //MARK: - Public Methods
    
    func addSupplementaryView(with text: String) {
        let labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 2
        
        guard let mainLabelText = self.titleLabel?.text else { return }
        
        mainLabel?.removeFromSuperview()
        supplementaryLabel?.removeFromSuperview()
        
        mainLabel = UILabel()
        supplementaryLabel = UILabel()
        
        guard let mainLabel = mainLabel,
              let supplementaryLabel = supplementaryLabel else { return }
        
        mainLabel.text = mainLabelText
        
        supplementaryLabel.text = text
        supplementaryLabel.textColor = .trackerGray
        
        [mainLabel,
         supplementaryLabel].forEach {
            labelsStackView.addArrangedSubview($0)
        }
        
        self.addSubview(labelsStackView)
        
        labelsStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        self.setTitle(nil, for: .normal)
    }
    
}

