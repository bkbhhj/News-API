import Foundation
import SDWebImage
final class NewsTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "NewsTableViewCell"
    private let imageTitle: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 1
        image.image = UIImage(systemName: "photo")
        return image
    }()
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    private let labelDescription: UILabel = {
        let labelDescription = UILabel()
        labelDescription.numberOfLines = 2
        labelDescription.adjustsFontSizeToFitWidth = true
        labelDescription.minimumScaleFactor = 0.7
        labelDescription.textColor = .black
        labelDescription.font = UIFont(name: "Avenir Next", size: 18)
        labelDescription.textAlignment = .left
        return labelDescription
    }()
    var stringForURL = ""
    private let viewForTitle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255,
                                       green: 233/255,
                                       blue: 231/255,
                                       alpha: 0.85)
        return view
    }()
    // MARK: Init cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNewsCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup constraints
    private func setupNewsCell() {
        addSubview(imageTitle)
        addSubview(viewForTitle)
        addSubview(labelTitle)
        addSubview(labelDescription)
        // setup constraints
        setupConstraintsForImageTitle()
        setupConstraintsForTitle()
        setupConstraintsForLabelDescription()
        setupConstrainsForViewForTitle()
        
    }
    // MARK: - Configure constraints for  image title
    private func setupConstraintsForImageTitle() {
        imageTitle.translatesAutoresizingMaskIntoConstraints = false
        imageTitle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageTitle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        imageTitle.heightAnchor.constraint(equalToConstant: Constant.height).isActive = true
        
    }
    // MARK: - Configure constraints for title
    private func setupConstraintsForTitle() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.topAnchor.constraint(equalTo: viewForTitle.topAnchor, constant: 10 ).isActive = true
        labelTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    // MARK: - Configure constraints for description
    private func setupConstraintsForLabelDescription() {
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5 ).isActive = true
        labelDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        labelDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    // MARK: - Configure constraints for view for title
    private func setupConstrainsForViewForTitle() {
        viewForTitle.translatesAutoresizingMaskIntoConstraints = false
        viewForTitle.topAnchor.constraint(equalTo: topAnchor, constant: 180).isActive = true
        viewForTitle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        viewForTitle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        viewForTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    // MARK: Configure Cell
    func configureCell(with model: News) {
        guard let url = URL(string: model.urlToImage ?? "") else {return}
        imageTitle.sd_setImage(with: url)
        labelTitle.text = model.title
        labelDescription.text = model.content
        stringForURL = model.url
        
    }
    //MARK: - Configure cell for favoriteViewController
    func configureCellForFavoriteNews(with model: NewsEntity) {
        guard let url = URL(string: model.imageURL ?? "") else {return}
        imageTitle.sd_setImage(with: url)
        labelTitle.text = model.title
        labelDescription.text = model.content
        stringForURL = model.url
    }
    
}
