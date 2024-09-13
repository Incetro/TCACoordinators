import ComposableArchitecture
import FlowStacks
import Foundation
import SwiftUI

public extension TCARouter where ID == Int {
  /// Convenience initializer for managing screens in an `Array`, identified by index.
  init(
    _ store: Store<[Route<Screen>], IndexedRouterAction<Screen, ScreenAction>>,
    navigationViewModifier: NavigationViewModifier = UnchangedViewModifier(),
    withNavigation: Bool = true,
    @ViewBuilder root: @escaping () -> Root,
    @ViewBuilder screenContent: @escaping (Store<Screen, ScreenAction>) -> ScreenContent
  ) {
    self.init(
      store: store,
      identifier: { $1 },
      navigationViewModifier: navigationViewModifier,
      withNavigation: withNavigation,
      root: root,
      screenContent: screenContent
    )
  }
}
