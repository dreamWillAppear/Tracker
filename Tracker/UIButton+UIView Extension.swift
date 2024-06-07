import UIKit
import SnapKit

private var supplementaryTitleLabelKey: Void?

extension UIButton {
    
    private var supplementaryTitleLabel: UILabel? {
           get {
               return objc_getAssociatedObject(self, &supplementaryTitleLabelKey) as? UILabel
           }
           set {
               objc_setAssociatedObject(self, &supplementaryTitleLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }
  
    func addSupplementaryTitle(with text: String?) {
            guard let text = text else {
                removeSupplementaryTitle()
                return
            }
            
            if supplementaryTitleLabel == nil {
                let label = UILabel()
                label.textColor = .trackerGray
                label.font = .systemFont(ofSize: 17)
                self.addSubview(label)
                supplementaryTitleLabel = label
                
                self.titleLabel?.snp.makeConstraints({ make in
                    make.top.equalToSuperview().inset(15)
                    make.bottom.equalToSuperview().inset(38)
                    make.leading.equalToSuperview()
                })
                
                supplementaryTitleLabel?.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(39)
                    make.leading.equalToSuperview().inset(16)
                }
            }
            
            supplementaryTitleLabel?.text = text
        }
    
    func removeSupplementaryTitle() {
      //пробовал вернуть основной лейбл на место при помощи snp, но это начинает работать непредсказуемо и странно 
           supplementaryTitleLabel?.removeFromSuperview()
           supplementaryTitleLabel = nil
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
