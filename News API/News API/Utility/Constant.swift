import Foundation

enum Constant {
    // Network
  static let urlNews = "https://newsapi.org/v2/everything?apiKey=53b50c107ff04fab932893969fd0974e&q=Tesla"
  static let searchUrlNews = "https://newsapi.org/v2/everything?apiKey=53b50c107ff04fab932893969fd0974e&q="
    // Cell
  static let identifier = "NewsTableViewCell"
  static let photo = "photo"
  static let avenirNextFont = "Avenir Next"
  static let height = CGFloat(280)
  static let numberOfSection = 1
  static let heightForHeader: CGFloat = 320
  static let heightForHeaderInSection: CGFloat = 50
  static let padding: CGFloat = 20
    // Core data
  static let nameloadPersistentStores = "News_API"
  static let entityName = "NewsEntity"
    // Alert Controller Save
  static let saveTitle = "Save news"
  static let saveMessage = "This news has been added to the favorite list"
    // Alert Controller Delete
  static let deleteTitle = "Save news"
  static let deleteMessage = "This news has been removed from the favorite list"
    // Constants for NewsViewController
  static let leftBarButtonItemImage = "magnifyingglass"
  static let rightBarButtonItemImage = "list.star"
  static let searchBarPlaceholder = "Search Topic"
  static let headerLabel = "Top Headlines"
  static let addActionNews = "Add News"
}
