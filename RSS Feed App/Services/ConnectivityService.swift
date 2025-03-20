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
}

class ConnectivityService: ObservableObject, ConnectivityProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    @Published var isConnected: Bool = false
    @Published var connectionType: String = "Unknown"

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                
                if path.usesInterfaceType(.wifi) {
                    self?.connectionType = "Wi-Fi"
                } else if path.usesInterfaceType(.cellular) {
                    self?.connectionType = "Cellular"
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self?.connectionType = "Wired Ethernet"
                } else if path.usesInterfaceType(.other) {
                    self?.connectionType = "Other"
                } else {
                    self?.connectionType = "No Connection"
                    self?.isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }

    func checkInternetConnection() -> Bool {
        return isConnected
    }
}
