import UIKit
import WebKit
final class DetailNewsController: UIViewController {
    //MARK: Propreties
     let webView = WKWebView()
     var stringForUrl = ""
     //MARK: ViewDidLoad
     override func viewDidLoad() {
         view.addSubview(webView)
         configureWebView()
         loadRequest()
     }
     // MARK:  Load Request
     private func loadRequest() {
         guard let url = URL(string: self.stringForUrl) else { return }
         let urlRequest = URLRequest(url: url)
         self.webView.load(urlRequest)
         
     }
}

extension DetailNewsController {
    private func configureWebView() {
        webView.pin(to: view)
    }
}
