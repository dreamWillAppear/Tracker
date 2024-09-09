import UIKit
import SnapKit

class CategoryCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerBlack
        label.textAlignment = .left
        return label
    }()
    
    lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .center
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(categoryName: String, isSelected: Bool) {
        categoryLabel.text = categoryName
        checkmarkImageView.isHidden = !isSelected
    }
    
    private func setUI() {
        backgroundColor  = .trackerBackground
        contentView.layer.cornerRadius = 16
        
        [categoryLabel, checkmarkImageView].forEach() {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
