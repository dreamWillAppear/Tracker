import UIKit
import SnapKit

final class ColorSelectCollectionHeader: UICollectionReusableView {
    
    static let identifier = "ColorSelectHeaderView"
    
        let title: UILabel = {
            let label = UILabel()
            label.textColor = .trackerBlack
            label.font = .systemFont(ofSize: 19, weight: .bold)
            label.text = "Цвет"
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(title)
            setConstraints()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            addSubview(title)
            setConstraints()
        }
        
        private func setConstraints() {
            title.snp.makeConstraints { make in
                make.width.equalTo(149)
                make.height.equalTo(18)
                make.leading.equalToSuperview().inset(28)
            }
        }

}
