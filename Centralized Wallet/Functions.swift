//
// Functions.swift
// 20240603 GetBTCBalance

// Created by ddr5ecc.eth on 6/3/24.
// Imported by Stephen Lin on 6/16/24.



import Foundation

func fetchBitcoinBalance(for address: String, completion: @escaping (Double?) -> Void) {
    let urlString = "https://blockchain.info/q/addressbalance/\(address)"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        if let balanceString = String(data: data, encoding: .utf8),
           let balanceSatoshi = Double(balanceString) {
            // Blockchain API returns balance in satoshi (1 BTC = 100,000,000 satoshi)
            completion(balanceSatoshi / 100_000_000)
        } else {
            completion(nil)
        }
    }
    
    task.resume()
}


