//
//  ScannerViewModel.swift
//  QrReader
//
//  Created by 金子 on 2022/08/27.
//

import Foundation

class ScannerViewModel: ObservableObject {

    /// QRコードを読み取る時間間隔
    let scanInterval: Double = 1.0
    @Published var lastQrCode: String = "QRコード"
    @Published var isShowing: Bool = false

    /// QRコード読み取り時に実行される。
    func onFoundQrCode(_ code: String) {
        syncHttpRequest(code)
        self.lastQrCode = code
        isShowing = false
    }
    
    var semaphore : DispatchSemaphore!

    func syncHttpRequest(_ url: String)
    {
        semaphore = DispatchSemaphore(value: 0)

        // Httpリクエストの生成
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        // HTTPリクエスト実行
        URLSession.shared.dataTask(with: request, completionHandler: requestCompleteHandler).resume()

        // requestCompleteHandler内でsemaphore.signal()が呼び出されるまで待機する
        semaphore.wait()
        print("request completed")
        self.lastQrCode = "request completed"
    }

    func requestCompleteHandler(data:Data?,res:URLResponse?,err:Error?)
    {
        print("response recieve")
        semaphore.signal()
    }
}
