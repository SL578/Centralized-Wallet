//
// ContentView.swift
// 20240604 Address Data

// Created by ddr5ecc.eth on 6/4/24.


import SwiftUI

struct ContentView: View {
    @StateObject internal var AD = AddressesData()
    @State internal var showActionSheet = false
    @State internal var selectedType: String?
    @State internal var bitcoinAddress1: String = "1EzwoHtiXB4iFwedPr49iywjZn2nnekhoj"
    @State internal var bitcoinAddress2: String = "1FfmbHfnpaZjKFvyi1okTjJJusN455paPH"
    @State internal var bitcoinBalance1: Double?
    @State internal var bitcoinBalance2: Double?
    @State internal var priceBTC: String = "Loading..."
    @State internal var walletValue: Double?
    internal var fetcher = BitcoinPriceFetcher()
    
    var body: some View {
            NavigationView {
                VStack(alignment: .leading, spacing: 3) {
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 2))
                    .onAppear {
                        fetchBitcoinPrice(fetcher: fetcher) { price in
                            DispatchQueue.main.async {
                                self.priceBTC = price ?? "Error fetching price"
                            }
                        }
                    }
                    
                    Divider()
                    
                    Text("Bitcoin addresses:")
                        .padding()
                    TextField("Enter Bitcoin Address", text: $bitcoinAddress1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Enter Bitcoin Address", text: $bitcoinAddress2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        fetchBitcoinBalance(for: bitcoinAddress1) { balance in
                            DispatchQueue.main.async {
                                self.bitcoinBalance1 = balance
                            }
                        }
                        fetchBitcoinBalance(for: bitcoinAddress2) { balance in
                            DispatchQueue.main.async {
                                self.bitcoinBalance2 = balance
                            }
                        }
                    }) {
                        Text("Get Balance")
                    }
                    .padding()
/*
                    var totalValue = 0
                    ForEach(getAddressesLength()){ Address in
                        if let balance = Address.balance, let price = Double(priceBTC) {
                            Text("Balance for address  \(Address.address): \n")
                            totalValue += balance * priceBTC
                        }
                        else{
                            continue()
                        }
                     }
                     Text("Total value combined: (totalValue))
                     
                    if let balance1 = bitcoinBalance1, let balance2 = bitcoinBalance2, let price = Double(priceBTC) {
                        Text("Balance for wallet 1: \(balance1) BTC\nBalance for wallet 2: \(balance2) BTC\n" +
                             "Value combined approx: \(String(format: "%.2f", (balance1 + balance2) * price)) USD")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.black, lineWidth: 2))
                    } else {
                        Text("Balance: N/A")
                            .padding()
                    }
                    */
                    
                    //Text(String(AD.combinedValue()))
                    
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
                    AddressListView(type: type, AddressesData: AD)
                    // 這段是一個 closure, 接收參數 type, 也就是 $selectedType 的值
                    // 注意此處有 $, 即 binding, 會監控這個值的變化
                    // 當值產生變化時，.sheet 會自動將這個 item 傳給後面的 closure, 剛好 type 就是接收的參數名稱
                    // 將這個 type 的值交給 AddressListView(), 這個函數需要兩個參數
                    // 一個是要顯示 BTC 還是 ETH
                    // 另一個是指定資料庫的位置
                    // 出現一個底部彈出視窗，該彈出視窗的內容來自 AddressListView.
                    // 當 $selectedType 存在值(非nil)的時候，就出現 sheet.
            }
        }
    }
}


#Preview {
    ContentView()
}
