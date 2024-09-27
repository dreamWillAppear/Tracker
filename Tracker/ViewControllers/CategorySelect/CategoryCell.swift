import UIKit
import SnapKit

class CategoryCell: UITableViewCell {
    
    //MARK: - Public Properties
    
    static let reuseIdentifier = "CategoryCell"
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerBlack
        label.textAlignment = .left
        return label
    }()
    
    private  lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .center
        imageView.isHidden = true
        return imageView
    }()
    
    //MARK: - Public Methods
    
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
    
    func isSelected(selected: Bool) {
        checkmarkImageView.isHidden = !selected
    }
    
    //MARK: - Private Methods
    
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
