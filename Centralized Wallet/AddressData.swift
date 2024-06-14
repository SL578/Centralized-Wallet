//
// AddressData.swift
// 20240604 Address Data

// Created by ddr5ecc.eth on 6/4/24.
// Imported by Stephen Lin on 6/15/24.


import Foundation

struct Address: Identifiable, Codable {
    let id = UUID()
    var type: String
    var address: String
    var balance: Double?
}

extension String: Identifiable {
    public var id: String { self }
}


class DataManager: ObservableObject {
    // ObservableObject 類別會被 View 觀察是否有變動
    
    @Published var addresses: [Address] = []
        // @ 代表 View 會依數值變化而更新
        // 陣列名稱 adresses, 內部的元素裝入 Address
    
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
}

