//
//  Product.swift
//  RecoilSwiftExample
//
//  Created by Roman Baev on 21.02.2024.
//

import Foundation

struct Product: Identifiable, Hashable {
  let id: UUID
  let name: String
}

func mockProducts() -> [Product] {
  return [
    Product(id: .init(), name: "iPhone"),
    Product(id: .init(), name: "iPad Pro"),
    Product(id: .init(), name: "Macbook Air"),
    Product(id: .init(), name: "Macbook Pro 14"),
    Product(id: .init(), name: "Macbook Pro 16"),
    Product(id: .init(), name: "iMac 27"),
  ]
}
