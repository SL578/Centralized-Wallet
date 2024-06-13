//
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

