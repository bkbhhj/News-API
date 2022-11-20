import UIKit
//MARK: - NewsViewControllerProtocol
protocol NewsViewControllerProtocol: AnyObject {
    var viewModel: NewsViewModelProtocol { get }
}

final class NewsViewController: UIViewController,NewsViewControllerProtocol {
    //MARK: - Properties
    var viewModel: NewsViewModelProtocol
    private var isSearching = false
    private var isLoaded = false
    // MARK: - UI Properties
    let tableViewNews: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.rowHeight = Constant.height
        return table
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.tintColor = .label
        return spinner
    }()
    //MARK: - Init
    init(viewModel: NewsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewNews()
        binding()
        configureNavigationController()
        configureSpinner()
        setupSearchController()
    }
    //MARK: - Configure Navigation controller
    private func configureNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(openSearch))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .done, target: self, action: #selector(openFavoriteVC))
    }
    @objc func openSearch() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    @objc func openFavoriteVC() {
        let favoritesNewsController = FavoriteViewController()
        navigationController?.pushViewController(favoritesNewsController, animated: true)
    }
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Topic"
        navigationItem.searchController = searchController
    }
    //MARK: - Configure spinner
    private func configureSpinner() {
        view.addSubview(spinner)
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    // MARK: - Configure TableViewNews
    private func configureTableViewNews() {
        view.addSubview(tableViewNews)
        tableViewNews.dataSource = self
        tableViewNews.delegate = self
        tableViewNews.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableViewNews.pin(to: view)
    }
    // MARK: - Binding
    private func binding() {
        viewModel.news.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.isLoaded = true
                self?.tableViewNews.reloadData()
            }
        }
        viewModel.isLoading.bind { [weak self] isLoading in DispatchQueue.main.async {
            if !isLoading {
                self?.spinner.stopAnimating()
            } else {
                self?.isLoaded = false
                self?.tableViewNews.reloadData()
            }
        }
        }
    }
}
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: Setup Headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.numberOfSection
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(
            x: Constant.padding,
            y: 0,
            width: view.frame.size.width - Constant.padding,
            height: Constant.heightForHeaderInSection))
        headerLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        headerView.addSubview(headerLabel)
        headerLabel.text = "Top Headlines"
        return headerView
    }
    // MARK: TableView number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.value.count
    }
    // MARK: TableView cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        let news = viewModel.news.value[indexPath.row]
        cell.configureCell(with: news)
        return cell
    }
    
    // MARK: - Transihion to url
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsController = DetailNewsController()
        let urlString = viewModel.news.value[indexPath.row].url
        detailNewsController.stringForUrl = urlString
        navigationController?.pushViewController(detailNewsController, animated: true)
    }
    // MARK: - Add news to favorite list
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addActionNews = UIContextualAction(style: .normal, title: "Add News") { [weak self]  _,_,
            completion in
            guard let newsSaveTitle = self?.viewModel.news.value[indexPath.row].title
            else {return}
            guard let newsSaveContent = self?.viewModel.news.value[indexPath.row].content
            else {return}
            guard let newsSaveUrl = self?.viewModel.news.value[indexPath.row].url
            else {return}
            guard let newsSaveImageUrl = self?.viewModel.news.value[indexPath.row].urlToImage
            else {return}
            let saveNews = News(title: newsSaveTitle,
                                url: newsSaveUrl,
                                urlToImage: newsSaveImageUrl,
                                content: newsSaveContent)
            self?.tableViewNews.reloadRows(at: [indexPath], with: .middle)
            CoreDataManager.shared.saveNews(News: saveNews)
            self?.displayNotificationAndDismissIn2Second(notificationTitle: "Cохранение данных",
                                   notificationMessage: "Эта новость добавлена в раздел избранное")
            completion(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [addActionNews])
        return swipeActions
    }
}

//MARK: - Extension SearchBar
extension NewsViewController: UISearchBarDelegate {
    //TODO: - Dispatch work item
    //MARK: search functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        spinner.startAnimating()
        viewModel.searchText = searchText
        if searchText == "" {
            isSearching = false
            viewModel.getTopNews()
        } else {
            isSearching = true
            viewModel.searchNews(query: searchText)
        }
    }
}
