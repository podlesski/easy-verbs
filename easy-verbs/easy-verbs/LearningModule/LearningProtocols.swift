import UIKit

protocol LearningViewProtocol: class {
    var score: Int { get }
    func scoreUpdate()
}

protocol LearningPresenterProtocol: class {
    var bestScore: Int { get }
    func onViewDidLoad()
    func randomElement() -> (verb: IrregularVerb?, tense: Int)
    func scoreServerUpdate()
}
