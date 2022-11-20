import UIKit

final class FavoriteViewController: UIViewController {
    //MARK: - Properties
    private let favoriteTableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        table.rowHeight = Constant.height
        return table
    }()
    var favoriteList = [NewsEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favoriteTableView)
        configureTableView()
        loadDataFromCoreDataManager()
    }
    // MARK: - load News from COREDATA Manager
    private func loadDataFromCoreDataManager(){
        CoreDataManager.shared.loadNews { results in
            self.favoriteList = results
        }
        self.favoriteTableView.reloadData()
    }
    //MARK: - Configure tableView
    private func configureTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.reloadData()
        favoriteTableView.pin(to: view)
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        let news = favoriteList[indexPath.row]
        cell.configureCellForFavoriteNews(with: news)
        return cell
    }
    // MARK: - Transihion to url
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsController = DetailNewsController()
        let urlString = favoriteList[indexPath.row].url
        detailNewsController.stringForUrl = urlString
        navigationController?.pushViewController(detailNewsController, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //MARK: Delete news in favorite list
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteList.remove(at: indexPath.row)
            CoreDataManager.shared.removeNews(at: indexPath.row)
            displayNotificationAndDismissIn2Second(notificationTitle: "Удаление  данных",
                              notificationMessage: "Эта новость удалена из раздела избранное")
            self.favoriteTableView.reloadData()
            self.favoriteTableView.deselectRow(at: indexPath, animated: true)
            self.loadDataFromCoreDataManager()
        }
        
    }
}
