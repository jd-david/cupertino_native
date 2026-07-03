import UIKit

func getRootVC() -> UIViewController? {
    var rootViewController: UIViewController? = nil
    if #available(iOS 13.0, *) {
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        rootViewController = window.rootViewController
                        break
                    }
                }
            }
        }
    }

    if rootViewController == nil {
        rootViewController = UIApplication.shared.keyWindow?.rootViewController
    }

    if rootViewController == nil {
        rootViewController = UIApplication.shared.delegate?.window??.rootViewController
    }
    return rootViewController
}
