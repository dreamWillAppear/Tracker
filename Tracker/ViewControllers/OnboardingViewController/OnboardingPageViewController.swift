import UIKit
import SnapKit

final class OnboardingPageViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var backgroundImage: UIImage
    private var labelText: String
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = labelText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .trackerBlack
        return label
    }()
    
    private lazy var amazingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .trackerBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.tintColor = .trackerWhite
        button.setTitle("Вот это технологии!", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapThatAmazingButton),
            for: .touchUpInside
        )
        return button
    }()
    
    //MARK: - Public Methods
    
    init(backgroundImage: UIImage, labelText: String) {
        self.backgroundImage = backgroundImage
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    //MARK: - Private Methods
    
    private func setUI() {
        [backgroundImageView, label, amazingButton].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(340)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        amazingButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(84)
        }
    }
    
    //MARK: - Actions
    
    @objc private func didTapThatAmazingButton() {
        self.dismiss(animated: true)
    }
}
