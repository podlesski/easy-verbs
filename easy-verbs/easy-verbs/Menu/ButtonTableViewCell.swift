import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    
    func didTapOnMenuButton(with name: String)
}

class ButtonTableViewCell: UITableViewCell {
    
    let button = UIButton()
    let rightArrow = UIImageView()
    let leftArrow = UIImageView()
    weak var delegate: ButtonTableViewCellDelegate!
    var nameForSegue = String()
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontName: String = "Roboto-Bold"
        static let fontSize: CGFloat = 38.0
        static let buttonWidth: CGFloat = 140.0
        static let buttonHight: CGFloat = 100.0
        static let arrowWidth: CGFloat = 60.0
        static let arrowHight: CGFloat = 45.0
        static let arrowBottomMargin: CGFloat = -10.0
        static let trailingMargin: CGFloat = -50.0
        static let leadingMargin: CGFloat = 50.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func update(with newButton: UniqueButton) {
        //MARK: -> Cell Logic
        button.setTitle(newButton.name, for: .normal)
        if newButton.side == 2 {
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingMargin).isActive = true
            button.contentHorizontalAlignment = .left
            rightArrow.isHidden = true
        } else {
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingMargin).isActive = true
            leftArrow.isHidden = true
        }
        nameForSegue = newButton.id
    }
}

//MARK: -> Extension For Cell
private extension ButtonTableViewCell {
    func commonInit() {
        self.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.selectionStyle = .none
        setUpViews()
        setUpViewsConstraints()
    }
    
    func setUpViews() {
        setUpButton()
        setUpRightArrow()
        setUpLeftArrow()
    }
    
    func setUpViewsConstraints() {
        setUpButtonConstraint()
        setUpRightArrowConstraint()
        setUpLeftArrowConstraint()
    }
    
    //MARK: -> Set Up Button
    func setUpButton() {
        button.setTitleColor(UIColor(named: Constants.projectColor), for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.fontSize)
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .bottom
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        self.addSubview(button)
    }
    
    func setUpButtonConstraint() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHight),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    //MARK: -> Set Up Right Arrow
    func setUpRightArrow() {
        rightArrow.image = UIImage(named: "rightArrow")
        rightArrow.contentMode = .scaleAspectFit
        self.addSubview(rightArrow)
    }
    
    func setUpRightArrowConstraint() {
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightArrow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingMargin),
            rightArrow.widthAnchor.constraint(equalToConstant: Constants.arrowWidth),
            rightArrow.heightAnchor.constraint(equalToConstant: Constants.arrowHight),
            rightArrow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.arrowBottomMargin)
            ])
    }
    
    //MARK: -> Set Up Left Arrow
    func setUpLeftArrow() {
        leftArrow.image = UIImage(named: "leftArrow")
        leftArrow.contentMode = .scaleAspectFit
        self.addSubview(leftArrow)
    }
    
    func setUpLeftArrowConstraint() {
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftArrow.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingMargin),
            leftArrow.widthAnchor.constraint(equalToConstant: Constants.arrowWidth),
            leftArrow.heightAnchor.constraint(equalToConstant: Constants.arrowHight),
            leftArrow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.arrowBottomMargin)
            ])
    }
    
    @objc func tapOnButton(_ sender: Any) {
        guard delegate != nil else { return }
        self.delegate.didTapOnMenuButton(with: nameForSegue)
    }
}
