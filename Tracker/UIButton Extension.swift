import UIKit
import SnapKit

extension UIButton {
    func addSupplementaryTitle(with text: String?) {
        let view = UILabel()
        if let text = text {
            self.addSubview(view)
            view.text = text
            view.textColor = .trackerGray
            view.font = .systemFont(ofSize: 17)
            
            self.titleLabel?.snp.makeConstraints({ make in
                make.top.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(38)
                make.leading.equalToSuperview()

            })
            
            view.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(39)
                make.leading.equalToSuperview().inset(16)
            }
        }
    }
}

extension UIView {
     func makeTextFiled(withPlaceholder: String)  {
         let textField = UITextField(frame: CGRect(x: 16, y: 27, width: self.bounds.width - 64, height: 22))
         textField.placeholder = withPlaceholder
         textField.clearButtonMode = .whileEditing
         self.addSubview(textField)
         textField.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalToSuperview().inset(16)
             make.trailing.equalToSuperview().inset(16)
         }
     }
}
