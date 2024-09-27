import UIKit
import SnapKit

final class CategoryHeaderView: UICollectionReusableView {
    
    //MARK: - Public Properties
    
    static let identifier = "CategoryHeaderView"
    
    let categoryTitle: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    //MARK: - Public Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryTitle)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(categoryTitle)
        setConstraints()
    }
    
    //MARK: - Private Methods
    
    private func setConstraints() {
        categoryTitle.snp.makeConstraints { make in
            make.width.equalTo(149)
            make.height.equalTo(18)
            make.leading.equalToSuperview().inset(28)
        }
    }
    
}
