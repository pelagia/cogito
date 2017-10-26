//  Copyright © 2017 Koninklijke Philips Nederland N.V. All rights reserved.

import Quick
import Nimble

class AttestationActionsSpec: QuickSpec {
    override func spec() {
        describe("Finish") {
            it("dispatches FinishRejected when no token present") {
                let finishAction = AttestationActions.Finish(params: [:])
                let dispatchRecorder = DispatchRecorder<AttestationActions.FinishRejected>()
                finishAction.action(dispatchRecorder.dispatch, { return nil })
                expect(dispatchRecorder.count) == 1
            }

            it("dispatches FinishRejected when token is invalid") {
                let finishAction = AttestationActions.Finish(params: ["id_token": "invalid token"])
                let dispatchRecorder = DispatchRecorder<AttestationActions.FinishRejected>()
                finishAction.action(dispatchRecorder.dispatch, { return nil })
                expect(dispatchRecorder.count) == 1
            }

            it("dispatches FinishRejected when token has incorrect nonce") {
                let finishAction = AttestationActions.Finish(params: ["id_token": validToken])
                let dispatchRecorder = DispatchRecorder<AttestationActions.FinishRejected>()
                finishAction.action(dispatchRecorder.dispatch, { return nil })
                expect(dispatchRecorder.count) == 1
            }
        }
    }
}

private let validToken = "eyJhbGciOiJSUzI1NiIsInR5c" +
                         "CIgOiAiSldUIiwia2lkIiA6ICJ0U1huMHQtVV9MWUFnTXZacFM0aF9KQUE5Y1RZWWQ2MX" +
                         "M2aF8zT0dhLXVjIn0.eyJqdGkiOiJlN2NiZmY3Mi1lZDY3LTRkMTUtOGE2MC00NDdhMjl" +
                         "iZGVjMDkiLCJleHAiOjE1MDkwMTEyMjEsIm5iZiI6MCwiaWF0IjoxNTA5MDEwMzIxLCJp" +
                         "c3MiOiJodHRwOi8vZWMyLTM1LTE1OC0yMC0xNjEuZXUtY2VudHJhbC0xLmNvbXB1dGUuY" +
                         "W1hem9uYXdzLmNvbTo4MDgwL2F1dGgvcmVhbG1zL21hc3RlciIsImF1ZCI6ImNvZ2l0by" +
                         "IsInN1YiI6IjkzYWIxMjc1LWY3ZTItNGFmNi04YWE5LTRjYzM0YjdiZTMwNyIsInR5cCI" +
                         "6IklEIiwiYXpwIjoiY29naXRvIiwibm9uY2UiOiJhMGViMjkxYjhiYjYwMWVmMDhlNDVm" +
                         "MWZjZWMzNWI3YjMyYWNiNzllNTUyZjY2NjY0YzRhMjUzMzMzMGVlZTcxIiwiYXV0aF90a" +
                         "W1lIjoxNTA5MDEwMzIxLCJzZXNzaW9uX3N0YXRlIjoiMDYyNjFhN2EtMjgyZi00MTEzLT" +
                         "hmYmQtNTFiMzJhMTY5YjI2IiwiYWNyIjoiMSIsIm5hbWUiOiJEZW1vIFVzZXIiLCJwcmV" +
                         "mZXJyZWRfdXNlcm5hbWUiOiJkZW1vIiwiZ2l2ZW5fbmFtZSI6IkRlbW8iLCJmYW1pbHlf" +
                         "bmFtZSI6IlVzZXIiLCJlbWFpbCI6ImRlbW9AZXhhbXBsZS5jb20ifQ.OxBNXYenPWDO93" +
                         "XhNn9wa7thfuPW4hVarQd4ufZHNFKl2iagcByZ95rtGd065u-B5hSpgEcTXtencr2Gf5W" +
                         "mWvQbMvoskyP5DXVtpNTz_hYwbS6ga24f-tr-WKGG6cqJzXEgrsN4P0YJzP6Uv_GIiLU6" +
                         "qucGjpK-pNSN6kJr9IKlQEpow_ERkyVIFaBtuzVT0fi6nfIskKOwzhJwf0eK-VX7o6mJa" +
                         "fzinyXc1wC-rGNb5rtbHbC1qx8Se4-gp-G0EDTa3iChS7m_ZDdXjMmnp22poRv1M8W3Ft" +
                         "rnfAnMyyDxr8AZwTefCQN9-3ge3hmBS7nBjlrrYkmwSTpAlJGHOg"
private let validNonce = "a0eb291b8bb601ef08e45f1fcec35b7b32acb79e552f66664c4a2533330eee71"
