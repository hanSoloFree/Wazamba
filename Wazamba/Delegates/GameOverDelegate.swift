protocol GameOverDelegate {
    var won: Bool? { get set }
    func pushGameOverViewController()
}
