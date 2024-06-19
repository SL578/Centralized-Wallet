//
// ContentView.swift
// 20240604 Address Data

// Created by ddr5ecc.eth on 6/4/24.


import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var showActionSheet = false
    @State private var selectedType: String?
    @State private var bitcoinAddress: String = "1EzwoHtiXB4iFwedPr49iywjZn2nnekhoj"
    @State private var bitcoinBalance: Double?
    @State private var priceBTC: String = "Loading..."
    @State private var walletValue: Double?
    private var fetcher = BitcoinPriceFetcher()

    var body: some View {
        NavigationView {
            VStack {
                Text("BTC Price: \(priceBTC)")
                    .padding()
                Button("Fetch BTC Price") {
                    fetchBitcoinPrice(fetcher: fetcher) { price in
                        DispatchQueue.main.async {
                            self.priceBTC = price ?? "Error fetching price"
                        }
                    }
                }
                .padding()
                .onAppear {
                    fetchBitcoinPrice(fetcher: fetcher) { price in
                        DispatchQueue.main.async {
                            self.priceBTC = price ?? "Error fetching price"
                        }
                    }
                }
                Text("🌍")
                    .font(.system(size: 100))
                    .padding()
                TextField("Enter Bitcoin Address", text: $bitcoinAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    fetchBitcoinBalance(for: bitcoinAddress) { balance in
                        DispatchQueue.main.async {
                            self.bitcoinBalance = balance
                        }
                    }
                }) {
                    Text("Get Balance")
                }
                .padding()
                
                if let balance = bitcoinBalance {
                    Text("Balance: \(balance) BTC")
                        .padding()
                    Text("Value approx: \((balance * Double(priceBTC)!.rounded(.towardZero)).rounded(.towardZero)) USD")
                } else {
                    Text("Balance: N/A")
                        .padding()
                }
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
/*
//
// ContentView.swift
// 20240603 GetBTCBalance

// Created by ddr5ecc.eth on 6/3/24.



import SwiftUI




struct ContentView: View {
    @State private var bitcoinAddress: String = "1EzwoHtiXB4iFwedPr49iywjZn2nnekhoj"
    @State private var bitcoinBalance: Double?
    
    var body: some View {
        VStack {
            TextField("Enter Bitcoin Address", text: $bitcoinAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                fetchBitcoinBalance(for: bitcoinAddress) { balance in
                    DispatchQueue.main.async {
                        self.bitcoinBalance = balance
                    }
                }
            }) {
                Text("Get Balance")
            }
            .padding()
            
            if let balance = bitcoinBalance {
                Text("Balance: \(balance) BTC")
                    .padding()
            } else {
                Text("Balance: N/A")
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


// ContentView.swift
// 20240529 Coinbase Json

// Created by ddr5ecc.eth on 5/29/24.



import SwiftUI

// 定义 ContentView 结构体来显示数据
struct ContentView: View {
    @State private var priceBTC: String = "Loading..."
    private var fetcher = BitcoinPriceFetcher()

    var body: some View {
        VStack {
            Text("BTC Price: \(priceBTC)")
                .padding()
            Button("Fetch BTC Price") {
                fetchBitcoinPrice(fetcher: fetcher) { price in
                    DispatchQueue.main.async {
                        self.priceBTC = price ?? "Error fetching price"
                    }
                }
            }
            .padding()
        }
        .onAppear {
            fetchBitcoinPrice(fetcher: fetcher) { price in
                DispatchQueue.main.async {
                    self.priceBTC = price ?? "Error fetching price"
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
*/
