//  Copyright © 2017 Koninklijke Philips Nederland N.V. All rights reserved.

import UIKit
import AVFoundation
import QRCodeReader

class HomeViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var previewContainer: UIView!

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showCancelButton = false
            $0.showOverlayView = false
            $0.showSwitchCameraButton = false
            $0.startScanningAtLoad = false
        }

        let readerVC = QRCodeReaderViewController(builder: builder)
        addChildViewController(readerVC)
        previewContainer.addSubview(readerVC.view)
        readerVC.view.frame = CGRect(x: 0, y: 0,
                                     width: previewContainer.frame.size.width,
                                     height: previewContainer.frame.size.height)
        readerVC.delegate = self
        return readerVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.layer.borderColor = UIColor.darkGray.cgColor
        cameraButton.layer.borderWidth = 2
        cameraButton.layer.cornerRadius = cameraButton.bounds.size.width / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readerVC.stopScanning()
    }

    @IBAction func openScanner() {
        readerVC.startScanning()
    }

    @IBAction func closeScanner() {
        readerVC.stopScanning()
    }

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
    }
}
