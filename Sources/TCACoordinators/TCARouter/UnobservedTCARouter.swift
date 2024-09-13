@_spi(Internals) import ComposableArchitecture
import FlowStacks
import Foundation
import SwiftUI

/// UnobservedTCARouter manages a collection of Routes, i.e., a series of screens, each of which is either pushed or presented.
/// The TCARouter translates that collection into a hierarchy of SwiftUI views, and updates it when the user navigates back.
/// The unobserved router is used when the Screen does not conform to ObservableState.
struct UnobservedTCARouter<
    Screen: Hashable,
    ScreenAction,
    ID: Hashable,
    Root: View,
    ScreenContent: View,
    NavigationViewModifier: ViewModifier
>: View {
    let store: Store<[Route<Screen>], RouterAction<ID, Screen, ScreenAction>>
    let identifier: (Screen, Int) -> ID
    let root: () -> Root
    let screenContent: (Store<Screen, ScreenAction>) -> ScreenContent
    var navigationViewModifier: NavigationViewModifier
    var withNavigation: Bool
    
    init(
        store: Store<[Route<Screen>], RouterAction<ID, Screen, ScreenAction>>,
        identifier: @escaping (Screen, Int) -> ID,
        navigationViewModifier: NavigationViewModifier,
        withNavigation: Bool = true,
        @ViewBuilder root: @escaping () -> Root,
        @ViewBuilder screenContent: @escaping (Store<Screen, ScreenAction>) -> ScreenContent
    ) {
        self.store = store
        self.identifier = identifier
        self.screenContent = screenContent
        self.root = root
        self.navigationViewModifier = navigationViewModifier
        self.withNavigation = withNavigation
    }
    
    func scopedStore(index: Int, screen: Screen) -> Store<Screen, ScreenAction> {
        var screen = screen
        let id = identifier(screen, index)
        return store.scope(
            id: store.id(state: \.[index], action: \.[id: id]),
            state: ToState {
                screen = $0[safe: index]?.screen ?? screen
                return screen
            },
            action: {
                .routeAction(id: id, action: $0)
            },
            isInvalid: { !$0.indices.contains(index) }
        )
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            FlowStack(
                viewStore
                    .binding(
                        get: { $0 },
                        send: RouterAction.updateRoutes
                    ),
                withNavigation: withNavigation,
                navigationViewModifier: navigationViewModifier,
                root: root
            )
        }
    }
}
