import UIKit

protocol FavoritesViewControllerDelegate: AnyObject {
    func addFavoriteCity(with object: WeatherResponse?, or city: String?)
}

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: FavoritesViewControllerDelegate?
    
    var favorites = [WeatherResponse]()
    var notification = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFavorites()
        self.registerForKeyboardNotification()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let city = self.searchTextField.text else { return }
        self.delegate?.addFavoriteCity(with: nil, or: city)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func loadFavorites() {
        if let favorites = Manager.shared.loadFavorites() {
            self.favorites = favorites
        }
    }
    
//     MARK: Show/Hide Keyboard
    private func registerForKeyboardNotification() {
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.mainViewBottomConstraint.constant = 0
        } else {
            self.mainViewBottomConstraint.constant = keyboardScreenEndFrame.height
        }
        
        self.view.needsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        let object = favorites[indexPath.row]
        cell.configure(with: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if indexPath.row == 0 {
                self.alertWrongDeleting()
            } else {
                Manager.shared.deleteFavorite(numberOfRow: indexPath.row)
                self.loadFavorites()
                self.favoritesTableView.reloadData()
            }
            success(true)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        Manager.shared.json = Manager.shared.loadFavorites()?[indexPath.row]
        //        guard let city = Manager.shared.json?.location.name else { return }
        let object = favorites[indexPath.row] 
        self.delegate?.addFavoriteCity(with: object, or: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 10
    }
    
}

extension FavoritesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchTextField.delegate = self
        
        let city = self.searchTextField.text 
        self.delegate?.addFavoriteCity(with: nil, or: city)
        self.navigationController?.popViewController(animated: true)
        return true
    }
    
}

