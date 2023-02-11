
import UIKit

extension UIViewController {
  func displayNotificationAndDismissIn2Second(notificationTitle:String, notificationMessage: String) {
    let alert = UIAlertController(title: notificationTitle, message: notificationMessage, preferredStyle: .alert)
    self.present(alert, animated: true, completion: nil)
      // change to desired number of seconds
    let when = DispatchTime.now() + 1.1
    DispatchQueue.main.asyncAfter(deadline: when){
        // your code with delay
      alert.dismiss(animated: true, completion: nil)
    }
  }
  
}
