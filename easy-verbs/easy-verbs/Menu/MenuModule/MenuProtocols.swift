import Foundation
import UIKit

protocol MenuViewProtocol: class {
}

protocol MenuPresenterProtocol: class {
    var buttonsOnMenu: [UniqueButton] { get }
    func createNewVC(with name: String) -> UIViewController
}
