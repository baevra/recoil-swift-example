//
//  Badge.swift
//  RecoilSwiftExample
//
//  Created by Roman Baev on 21.02.2024.
//

import SwiftUI

struct Badge: View {
  let count: Int

  var body: some View {
    ZStack(alignment: .topTrailing) {
      Color.clear
      Text(String(count))
        .font(.system(size: 13))
        .foregroundStyle(Color.white)
        .padding(5)
        .background(Color.red)
        .clipShape(Circle())
      // custom positioning in the top-right corner
        .alignmentGuide(.top) { $0[.bottom] }
        .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
    }
  }
}
