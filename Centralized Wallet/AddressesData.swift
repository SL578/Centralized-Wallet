//
// AddressData.swift
// 20240604 Address Data

// Created by ddr5ecc.eth on 6/4/24.


import Foundation
import SwiftUI
internal var fetcher = BitcoinPriceFetcher()
struct Address: Identifiable, Codable {
    let id = UUID()
    var type: String
    var address: String
    var balance: Double?
}

extension String: Identifiable {
    public var id: String { self }
}


class AddressesData: ObservableObject {
    // ObservableObject 類別會被 View 觀察是否有變動
    
    @Published var addresses: [Address] = []
        // @ 代表 View 會依數值變化而更新
        // 陣列名稱 adresses, 內部的元素裝入 Address
    let CV = ContentView()
    
    init() {
        loadAddresses() // 一開始就載入已儲存的陣列
    }
    
    func getDocumentDirectory() -> URL {    // 本函數讓 iOS 可在 App 的目錄中讀寫檔案
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveAddresses() {
        let url = getDocumentDirectory().appendingPathComponent("addresses.json")
            // 在可存取的目錄中，存入檔案名稱為 addresses.json
        
        do {
            let data = try JSONEncoder().encode(addresses)
            try data.write(to: url)
        } catch {
            print("Failed to save addresses: \(error.localizedDescription)")
        }
    }
    
    func loadAddresses() {
        let url = getDocumentDirectory().appendingPathComponent("addresses.json")
            // 在可存取的目錄中，讀取檔案名稱為 addresses.json
        
        if FileManager.default.fileExists(atPath: url.path) {   // 檢查檔案存在否，若不存在，就不讀，代表是第一次啟用
            do {
                let data = try Data(contentsOf: url)    // 從 url 中讀取數據，存成 data
                addresses = try JSONDecoder().decode([Address].self, from: data)    // 將 data 解密，存在 address 陣列
            } catch {
                print("Failed to load addresses: \(error.localizedDescription)")
            }
        }
    }
    
    func combinedValue() -> Double {
        var totalValue = 0.0
        
        // Iterate with indices to modify elements in the array
        for i in addresses.indices {
            var address = addresses[i]
            
            // Synchronous fetch (assuming this is a synchronous call)
            fetchBitcoinBalance(for: address.address) { balance in
                DispatchQueue.main.sync {
                    address.balance = balance
                }
            }
            
            // Asynchronous fetch
            fetchBitcoinBalance(for: address.address) { balance in
                DispatchQueue.main.async {
                    // Update the address in the original array
                    self.addresses[i].balance = balance
                    
                    // Recalculate totalValue after updating balance
                    if let balance = addresses[i].balance, let price = Double(CV.priceBTC) {
                        totalValue += balance * price
                    }
                }
            }
            
            // Calculate totalValue with the synchronous fetch
            if let balance = address.balance, let price = Double(CV.priceBTC) {
                totalValue += balance * price
            }
        }
        
        return totalValue
    }

    /*
    func combinedValue() -> Double {
        var totalValue = 0.0
        for address in addresses {
            address.balance = CV.fetchBitcoinBalance(address.address)
            fetchBitcoinBalance(for: address.address) { balance in
                DispatchQueue.main.async {
                    address.address = balance
                }
            }
            if let balance = address.balance, let price = Double(CV.priceBTC) {
                totalValue += balance * Double(CV.priceBTC)!
            }
            totalValue += address.balance * Double(CV.priceBTC)!
        }
        return totalValue
    }*/

}


