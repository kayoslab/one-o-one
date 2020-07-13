// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Game: StoryboardType {
    internal static let storyboardName = "Game"

    internal static let initialScene = InitialSceneType<one_o_one.GameViewController>(storyboard: Game.self)

    internal static let game = SceneType<one_o_one.GameViewController>(storyboard: Game.self, identifier: "Game")
  }
  internal enum MainMenu: StoryboardType {
    internal static let storyboardName = "MainMenu"

    internal static let initialScene = InitialSceneType<one_o_one.MainMenuViewController>(storyboard: MainMenu.self)

    internal static let mainMenu = SceneType<one_o_one.MainMenuViewController>(storyboard: MainMenu.self, identifier: "MainMenu")
  }
  internal enum PurchaseMenu: StoryboardType {
    internal static let storyboardName = "PurchaseMenu"

    internal static let initialScene = InitialSceneType<one_o_one.PurchaseMenuViewController>(storyboard: PurchaseMenu.self)

    internal static let purchaseMenu = SceneType<one_o_one.PurchaseMenuViewController>(storyboard: PurchaseMenu.self, identifier: "PurchaseMenu")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
