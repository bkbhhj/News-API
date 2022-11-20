import UIKit

protocol NewsViewModelProtocol: AnyObject {
    var news: Observable<[News]> {get set}
    func getTopNews()
    func switchingCases(result: Result<ResponseNews, Error>)
    func successHandler(for result: ResponseNews)
    var searchText: String { get set }
    var isLoading: Observable<Bool> { get set }
    func searchNews(query: String)
}


final class NewsViewModel: NewsViewModelProtocol {
    let networkService: NetworkServiceProtocol
    var news: Observable<[News]>
    var searchText: String
    var isLoading: Observable<Bool>
    //MARK: - Init
    init(networkService: NetworkServiceProtocol, news: Observable<[News]>, searchText: String, isLoading: Observable<Bool>) {
        self.networkService = networkService
        self.news = news
        self.searchText = searchText
        self.isLoading = isLoading
        getTopNews()
    }
    
    //MARK: Network calls
    func getTopNews() {
        networkService.getNews(){ [weak self] result in
            self?.switchingCases(result: result)
        }
    }
    //MARK: search calls
    func searchNews(query: String) {
        networkService.searchNews(query: query) { [weak self] result in
            self?.switchingCases(result: result)
        }
    }
    // MARK: - Response Handlers
    func switchingCases(result: Result<ResponseNews, Error>) {
        switch result {
        case .success(let data):
            successHandler(for: data)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    // MARK: Sucsses handler
    func successHandler(for result: ResponseNews) {
        news.value = result.articles
        isLoading.value = false
    }
}
