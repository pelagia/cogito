import ReSwift

struct AccountService: TelepathService {
    let store: Store<AppState>

    func onRequest(_ request: JsonRpcRequest, on channel: TelepathChannel) {
        guard request.method == "accounts" else {
            return
        }
        store.dispatch(AccountActions.GetAccounts(requestId: request.id, channel: channel))
    }
}
