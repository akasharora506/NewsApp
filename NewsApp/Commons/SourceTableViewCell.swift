import UIKit

class SourceTableViewCellViewModel {
    let title: String
    let description: String
    let id: String
    init(
        id: String,
        title: String,
        description: String
    ) {
        self.title = title
        self.description = description
        self.id = id
    }
}

class SourceTableViewCell: UITableViewCell {
    static let identifier = "SourceTableViewCell"
    private let sourceName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let sourceDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sourceName)
        contentView.addSubview(sourceDescription)
        addConstraints()
    }
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(sourceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5))
        constraints.append(sourceName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(sourceName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        constraints.append(sourceName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5, constant: -10))
        constraints.append(sourceDescription.topAnchor.constraint(equalTo: sourceName.bottomAnchor, constant: 5))
        constraints.append(sourceDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        constraints.append(sourceDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        constraints.append(sourceDescription.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5, constant: -10))
        NSLayoutConstraint.activate(constraints)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceName.text = nil
        sourceDescription.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with viewModel: SourceTableViewCellViewModel) {
        sourceName.text = viewModel.title
        sourceDescription.text = viewModel.description
    }
}
