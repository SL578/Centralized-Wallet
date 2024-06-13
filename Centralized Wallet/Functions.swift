//
// Functions.swift
// 20240529 Coinbase Json

// Created by ddr5ecc.eth on 5/29/24.
// Imported by Stephen Lin on 6/13/24.



import Foundation

// 将获取比特币价格的函数放在 ContentView 外
func fetchBitcoinPrice(fetcher: BitcoinPriceFetcher, completion: @escaping (String?) -> Void) {
    fetcher.fetchBTCPrice(completion: completion)
}

