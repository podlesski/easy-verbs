import UIKit

final class MenuPresenter: MenuPresenterProtocol {
    weak var view: MenuViewProtocol?
    
    var buttonsOnMenu = [
        UniqueButton(name: "VOCAB LUARY", side: 1, id: "AllVerbsViewController"),
        UniqueButton(name: "FAVO RITES", side: 2, id: "FavoritesVerbsViewController"),
        UniqueButton(name: "TRAI NING", side: 1, id: "LearningViewController")]
    
    func createNewVC(with name: String) -> UIViewController {
        let newVC: UIViewController
        switch name {
        case "AllVerbsViewController":
            newVC = AllVerbsFactory.make()
            newVC.modalPresentationStyle = .fullScreen
        case "FavoritesVerbsViewController":
            newVC = FavoriteVerbsFactory.make()
            newVC.modalPresentationStyle = .fullScreen
        default:
            newVC = LearningFactory.make()
            newVC.modalPresentationStyle = .fullScreen
        }
        return newVC
    }
}
