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
    }
    
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

}
