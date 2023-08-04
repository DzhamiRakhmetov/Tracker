
import UIKit

final class ButtonCell: UITableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var descriptionlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setuUpViews()
        backgroundColor = .custom.backgroundDay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setuUpViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(descriptionlLabel)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    func setup(_ detail: String?) {
        descriptionlLabel.text = detail
    }
}
