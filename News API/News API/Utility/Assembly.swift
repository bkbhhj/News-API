import UIKit

final class Asembly {
  func configureNewsModule() -> UIViewController {
    let news = Observable([News]())
    let networkService = NetworkService()
    let coreDataService = CoreDataManager()
    let viewModel = NewsViewModel(networkService: networkService, coreDataService: coreDataService,
                                  news: news,
                                  searchText: "",
                                  isLoading: Observable(true))
    let configureViewController = NewsViewController(viewModel: viewModel)
    return configureViewController
  }
}
