//Copyright © 2017 Koninklijke Philips Nederland N.V. All rights reserved.

import Foundation
import ReSwift
import ReSwiftThunk

struct TelepathActions {
    // swiftlint:disable identifier_name
    static func Connect(url: URL) -> ThunkAction<AppState> {
        return ThunkAction { dispatch, _ in
            do {
                let channel = try TelepathChannel(connectUrl: url)
                dispatch(ConnectFulfilled(channel: channel))
            } catch let error {
                dispatch(ConnectRejected(error: error))
            }
        }
    }

    struct ConnectFulfilled: Action {
        let channel: TelepathChannel
    }

    struct ConnectRejected: Action {
        let error: Error
    }

    // swiftlint:disable identifier_name
    static func Receive() -> ThunkAction<AppState> {
        return ThunkAction { dispatch, getState in
            getState()?.telepath.channel?.receive { message, error in
                if let error = error {
                    dispatch(TelepathActions.ReceiveRejected(error: error))
                } else if let message = message {
                    dispatch(TelepathActions.ReceiveFulfilled(message: message))
                }
            }
        }
    }

    struct ReceiveFulfilled: Action {
        let message: String
    }

    struct ReceiveRejected: Action {
        let error: Error
    }

    struct Send: Action {
        let message: String
    }
}
