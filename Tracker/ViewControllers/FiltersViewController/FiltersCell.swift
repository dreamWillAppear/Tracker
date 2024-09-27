import UIKit

final class FiltersCell: UITableViewCell {
    
    static let reuseIdentifier = "FiltersCell"
    
    //MARK: - Private Properties
    
    private lazy var filterLabel: UILabel = {
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
    
    func configureCell(filterName: String, isSelected: Bool) {
        filterLabel.text = filterName
        checkmarkImageView.isHidden = !isSelected
    }
    
    func isSelected(selected: Bool){
        checkmarkImageView.isHidden = !selected
    }
    
    func getGetSelectedFilterName() -> String {
        filterLabel.text ?? ""
    }
    
    //MARK: - Private Methods
    
    private func setUI() {
        backgroundColor  = .trackerBackground
        contentView.layer.cornerRadius = 16
        
        [filterLabel, checkmarkImageView].forEach() {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        filterLabel.snp.makeConstraints { make in
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
