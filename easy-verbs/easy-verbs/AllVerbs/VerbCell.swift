import UIKit

protocol VerbCellDelegate: AnyObject {
    func didTapOnVerbButton(with verb: IrregularVerb?)
}

class VerbCell: UITableViewCell {

    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontName: String = "Roboto-Bold"
        static let fontSize: CGFloat = 38.0
        static let additionalContentSpace: CGFloat = 240.0
        static let leadingMargin: CGFloat = 20.0
        static let distanceBetweenButtons: CGFloat = 100.0
    }

    private let scrollView = UIScrollView()
    private let verbButton = UIButton()
    private let verbPast = UIButton()
    private let verbPastPerfect = UIButton()
    private let containerView = UIView()

    weak var delegate: VerbCellDelegate!
    var verb: IrregularVerb?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let buttonsContentWidth = verbButton.frame.width + verbPast.frame.width + verbPastPerfect.frame.width + Constants.additionalContentSpace
        scrollView.contentSize = CGSize(width: buttonsContentWidth, height: contentView.frame.height)
    }

    func update(with newVerb: IrregularVerb) {
        verbPast.setTitle(newVerb.pastSimple?.uppercased(), for: .normal)
        verbButton.setTitle(newVerb.infinitive?.uppercased(), for: .normal)
        verbPastPerfect.setTitle(newVerb.pastParticiple?.uppercased(), for: .normal)
        verb = newVerb
    }
}

// MARK: Set up and configure Views

private extension VerbCell {
    func commonInit() {
        setupHierarchy()
        setupViewsConstraints()
        configureViews()
    }

    func setupHierarchy() {
        self.contentView.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(verbPast)
        containerView.addSubview(verbButton)
        containerView.addSubview(verbPastPerfect)
    }

    func setupViewsConstraints() {
        setUpScrollViewConstraint()
        setUpScrollContentConstraint()
        setUpVerbPastConstraint()
        setUpVerbButtonConstraint()
        setUpVerbPerfectConstraint()
    }

    func configureViews() {
        setupButtons([verbPastPerfect, verbPast, verbButton])
        self.backgroundColor = UIColor(named: Constants.secondProjectColor)
    }

    func setUpScrollViewConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    func setUpScrollContentConstraint() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setUpVerbButtonConstraint() {
        verbButton.translatesAutoresizingMaskIntoConstraints = false
        verbButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        verbButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.leadingMargin).isActive = true
    }

    func setUpVerbPastConstraint() {
        verbPast.translatesAutoresizingMaskIntoConstraints = false
        verbPast.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        verbPast.leadingAnchor.constraint(equalTo: verbButton.trailingAnchor, constant: Constants.distanceBetweenButtons).isActive = true
    }

    func setUpVerbPerfectConstraint() {
        verbPastPerfect.translatesAutoresizingMaskIntoConstraints = false
        verbPastPerfect.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        verbPastPerfect.leadingAnchor.constraint(equalTo: verbPast.trailingAnchor, constant: Constants.distanceBetweenButtons).isActive = true
    }

    func setupButtons(_ buttons: [UIButton]) {
        buttons.forEach {
            $0.setTitleColor(UIColor(named: Constants.projectColor), for: .normal)
            $0.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.fontSize)
            $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        }
    }

    @objc func tapButton(_ sender: Any) {
        delegate?.didTapOnVerbButton(with: verb)
    }
}
