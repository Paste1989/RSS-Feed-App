//
//  ConnectivityService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 13.03.2025..
//

import Foundation
import Network

protocol ConnectivityProtocol {
    func checkInternetConnection() -> Bool
    var isConnected: Bool { get set }
}

class ConnectivityService: ObservableObject, ConnectivityProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var isConnected: Bool = false
    
    func checkInternetConnection() -> Bool {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
        return isConnected
    }
}
