import Foundation
  //MARK: - Model News
struct ResponseNews: Decodable {
  let articles: [News]
}

struct News: Decodable {
  let title: String
  let url: String
  let urlToImage: String?
  let content: String?
}
