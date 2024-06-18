//
// AddressListView.swift
// 20240604 Address Data

// Created by ddr5ecc.eth on 6/4/24.


import SwiftUI

struct AddressListView: View {
    let type: String    // 決定本 View 要顯示的是 BTC, 還是 ETH
    @ObservedObject var dataManager: DataManager
        // 變數 dataManager 會被觀察以更新 View, DataManager 是一個 Class, 內有一個 addresses 變數儲存地址資訊
        // 存取陣列時要使用 dataManager.addresses
    @State private var newAddress: String = ""      // 新地址，預設為空

    var body: some View {
        VStack {
            List {
                ForEach(dataManager.addresses.filter { $0.type == type }) { address in
                    // ForEach 會遍歷所有的 dataManager.addresses, 並過瀘選取的是 BTC 還是 ETH
                    // $0 是指當前處理的元素 $0.type == type, 代表當前的元素幣種要正確才行
                    // 過濾出來之後，傳給後面 address in 做為參數
                    Text(address.address)   // 對每一個 address, 印出 address 資訊
                }
                
                // 以下 .onDelete 支援多重刪除，但要在編輯模式下才能多重刪除，要進入編輯模式並多選才能達到多選刪除，以後再說
                .onDelete { indexSet in
                    // 當刪除鈕一按下，將選擇的這個地址做為索引並傳給 closure 準備過濾出來並刪除

                    let currentTypeAddresses = dataManager.addresses.filter { $0.type == type }
                        // 得知目前 View 究竟是 BTC 還是 ETH

                    let filtered = currentTypeAddresses.enumerated().filter { indexSet.contains($0.offset) }
                        // 比如目前是 BTC 的 View, 對這個 View 的位置找出對應的 indexSet
                    
                    for (_, element) in filtered {
                        // 為何使用底線：每一個元素包含 (offset, address), 而 offset 的順序在此是不重要的
                        // 我們只要後面的 address, 取出 address 的 id，並予以刪除即可
                        dataManager.addresses.removeAll { $0.id == element.id }
                            // 每一個位置目前是用 element 表達，要找 element.id 相同的
                            // $0 代表當前的元素，即當前的地址
                            // 若當前地址的 ID 等於 過濾出來地址的 ID, 就刪除當前地址
                    }
                    dataManager.saveAddresses() //dataManager是物件，saveAddresses() 是該物件有的函數，寫入資料庫
                }

                
                
                        

                
            }
            
            HStack {
                TextField("Enter \(type) address", text: $newAddress)   // 接受使用者輸入，寫入 $newAddress 變數
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add") {
                    guard !newAddress.isEmpty else { return }   // 確保 newAddress 要有數值才寫入。若無數值，按下 Add 就不做寫入
                    let address = Address(type: type, address: newAddress, balance: nil)    // 設定新地址資料
                    dataManager.addresses.append(address)   // 寫入資料庫
                    dataManager.saveAddresses() // 儲存資料庫
                    newAddress = "" // 再將新地址欄位清空
                }
                .padding(.leading)
            }
            .padding()
        }
        .navigationBarTitle(Text("\(type) Addresses"))
    }
}


