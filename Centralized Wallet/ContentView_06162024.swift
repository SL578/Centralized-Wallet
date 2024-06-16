//
// ContentView.swift
// 20240603 GetBTCBalance

// Created by ddr5ecc.eth on 6/3/24.
// Imported by Stephen Lin on 6/16/24.


import SwiftUI




struct ContentView_06162024: View {
    @State private var bitcoinAddress: String = "1FfmbHfnpaZjKFvyi1okTjJJusN455paPH"
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
    ContentView_06162024()
}

