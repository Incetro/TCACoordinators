//
//  UnchangedViewModifier.swift
//
//
//  Created by Gleb Kovalenko on 13.09.2024.
//

import SwiftUI

/// A view modifier that makes no changes to the content.
public struct UnchangedViewModifier: ViewModifier {
    
  public init() {}
  public func body(content: Content) -> some View {
    content
  }
}
