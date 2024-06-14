//
// ContentView.swift
// 20240604 Address Data

// Created by ddr5ecc.eth on 6/4/24.
// Imported by Stephen Lin on 6/14/24.



import SwiftUI

struct ContentView_new: View {
    @StateObject private var dataManager = DataManager()
    @State private var showActionSheet = false
    @State private var selectedType: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("🌍")
                    .font(.system(size: 100))
                    .padding()
                
                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showActionSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .imageScale(.large)
            })
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Select Cryptocurrency"),
                    buttons: [
                        .default(Text("BTC")) {
                            selectedType = "BTC"
                        },
                        .default(Text("ETH")) {
                            selectedType = "ETH"
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(item: $selectedType) { type in
                AddressListView(type: type, dataManager: dataManager)
                // 這段是一個 closure, 接收參數 type, 也就是 $selectedType 的值
                // 注意此處有 $, 即 binding, 會監控這個值的變化
                // 當值產生變化時，.sheet 會自動將這個 item 傳給後面的 closure, 剛好 type 就是接收的參數名稱
                // 將這個 type 的值交給 AddressListView(), 這個函數需要兩個參數
                // 一個是要顯示 BTC 還是 ETH
                // 另一個是指定資料庫的位置

            }   // 出現一個底部彈出視窗，該彈出視窗的內容來自 AddressListView.
                // 當 $selectedType 存在值(非nil)的時候，就出現 sheet.
                //
        }
    }
}


#Preview {
    ContentView()
}

