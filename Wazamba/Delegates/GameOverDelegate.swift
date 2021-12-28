protocol GameOverDelegate {
    var won: Bool? { get set }
    var currentLevel: Int? { get set }
    func pushGameOverViewController()
}
