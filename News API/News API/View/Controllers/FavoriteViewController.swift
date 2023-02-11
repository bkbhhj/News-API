import UIKit
protocol FavoriteViewControllerProtocol: AnyObject {
  var coreData: CoreDataServiceProtocol { get set}
}
final class FavoriteViewController: UIViewController, FavoriteViewControllerProtocol {
  
  var coreData: CoreDataServiceProtocol
  init(coreData: CoreDataServiceProtocol) {
    self.coreData = coreData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
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
    coreData.loadNews { [weak self] result in
      guard let self = self else {return }
      self.favoriteList = result
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
      coreData.removeNews(at: indexPath.row)
      displayNotificationAndDismissIn2Second(notificationTitle: Constant.deleteTitle,
                                             notificationMessage: Constant.deleteMessage)
      self.favoriteTableView.reloadData()
      self.favoriteTableView.deselectRow(at: indexPath, animated: true)
      self.loadDataFromCoreDataManager()
    }
    
  }
}
