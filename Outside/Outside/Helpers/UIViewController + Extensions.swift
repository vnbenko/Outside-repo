import UIKit

extension UIViewController {
    func alertWrongDeleting () {
        let alert = UIAlertController(title: "Oops!", message: "Your city can't be deleted", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(firstAction)
        self.present(alert, animated: true, completion: nil)
    }
}




