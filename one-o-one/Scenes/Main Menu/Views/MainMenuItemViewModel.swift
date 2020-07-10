import UIKit

struct MainMenuItemViewModel {
    private let menuItem: Game
    let index: Int

    var backgroundColor: UIColor {
        return menuItem.backgroundColor
    }

    init(with menuItem: Game, index: Int) {
        self.menuItem = menuItem
        self.index = index
    }
}
