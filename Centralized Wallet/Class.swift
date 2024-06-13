//
// Class.swift
// 20240529 Coinbase Json

// Created by ddr5ecc.eth on 5/29/24.
// Imported by Stephen Lin on 6/13/24.


import Foundation

// 定义结构体来解析 JSON
struct CoinbaseResponse: Decodable {
    let data: PriceData
}

struct PriceData: Decodable {
    let amount: String
}

// 创建一个类来处理网络请求
class BitcoinPriceFetcher {
    func fetchBTCPrice(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api.coinbase.com/v2/prices/BTC-USD/spot") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data")
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(CoinbaseResponse.self, from: data)
                completion(result.data.amount)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

