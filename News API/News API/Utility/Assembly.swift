import UIKit

final class Asembly {
    func configureNewsModule() -> UIViewController {
        let news = Observable([News]())
        let networkService = NetworkService()
        let viewModel = NewsViewModel(networkService: networkService,
            news: news,
            searchText: "",
            isLoading: Observable(true))
        let configureViewController = NewsViewController(viewModel: viewModel)
        return configureViewController
    }
}
