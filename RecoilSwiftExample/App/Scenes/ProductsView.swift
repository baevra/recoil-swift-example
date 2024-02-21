//
//  ProductsView.swift
//  RecoilSwiftExample
//
//  Created by Roman Baev on 21.02.2024.
//

import SwiftUI
import RecoilSwiftFramework

let productsState = atom(
  key: "products",
  defaultValue: {
    try await Task.sleep(for: .seconds(1))
    return mockProducts()
  }
)

let productsSearchState = atom(
  key: "products search",
  defaultValue: ""
)

let filteredProductsState = selector(
  key: "filtered products",
  get: { ctx in
    let searchText = ctx.get(productsSearchState)
    let products = try await ctx.get(productsState)
    try await Task.sleep(for: .milliseconds(400))
    if searchText.isEmpty { return products }
    return products.filter { $0.name.contains(searchText) }
  }
)

let cartProductsState = atom(
  key: "cart products",
  defaultValue: [Product]()
)

let cartCountState = selector(
  key: "cart count",
  get: { ctx in
    let cartProducts = ctx.get(cartProductsState)
    return cartProducts.count
  }
)

let addToCartCallback: RecoilAsyncParameterCallback<Product, Bool> = { (ctx, product) in
  try await Task.sleep(for: .seconds(1))
  let products = ctx.get(cartProductsState)
  ctx.set(cartProductsState, products + [product])
  return true
}

struct ProductView: View {
  let product: Product
  @StateObject var addToCart = useRecoilCallback(addToCartCallback)
  @State var isLoading = false

  var body: some View {
    HStack {
      Text(product.name)
      Spacer()
      Button(action: {
        Task {
          isLoading = true
          _ = try? await addToCart(parameter: product)
          isLoading = false
        }
      }) {
        if isLoading {
          ProgressView()
        } else {
          Image(systemName: "cart.badge.plus")
        }
      }
    }
  }
}

struct ProductsView: View {
  @StateObject var products = useRecoilState(filteredProductsState)
  @StateObject var search = useRecoilState(productsSearchState)
  @StateObject var cartProducts = useRecoilState(cartProductsState)
  @StateObject var cartCount = useRecoilState(cartCountState)

  var body: some View {
    NavigationStack {
      Group {
        switch products.state {
        case .loading:
          List(mockProducts()) { product in
            ProductView(product: product)
              .redacted(reason: .placeholder)
          }
        case let .success(products):
          List(products) { product in
            ProductView(product: product)
          }
        case let .failure(error):
          Text(error.localizedDescription)
        }
      }
      .navigationTitle("Products")
      .toolbar {
        Button(
          action: {},
          label: { Image(systemName: "cart") }
        )
        .overlay { Badge(count: cartCount.value + cartProducts.value.count) }
      }
      .listStyle(.plain)
      .searchable(text: .init(get: { search.value }, set: { search.value = $0 }))
    }
  }
}

