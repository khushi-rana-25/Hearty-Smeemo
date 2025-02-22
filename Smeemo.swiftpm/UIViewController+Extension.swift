
import UIKit
import SwiftUI

// This helps get the current UIViewController inside SwiftUI
@MainActor
extension UIViewController {
    static func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let rootVC = window.rootViewController else {
            return nil
        }
        return rootVC
    }
}
