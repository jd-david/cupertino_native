import Flutter
import UIKit

public class CupertinoNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cupertino_native", binaryMessenger: registrar.messenger())
    let instance = CupertinoNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register platform view factories
    let sliderFactory = CupertinoSliderViewFactory(messenger: registrar.messenger())
    registrar.register(sliderFactory, withId: "CupertinoNativeSlider")

    let switchFactory = CupertinoSwitchViewFactory(messenger: registrar.messenger())
    registrar.register(switchFactory, withId: "CupertinoNativeSwitch")

    // Segmented control
    let segmentedFactory = CupertinoSegmentedControlViewFactory(messenger: registrar.messenger())
    registrar.register(segmentedFactory, withId: "CupertinoNativeSegmentedControl")

    let iconFactory = CupertinoIconViewFactory(messenger: registrar.messenger())
    registrar.register(iconFactory, withId: "CupertinoNativeIcon")

    let tabBarFactory = CupertinoTabBarViewFactory(messenger: registrar.messenger())
    registrar.register(tabBarFactory, withId: "CupertinoNativeTabBar")

    let popupMenuFactory = CupertinoPopupMenuButtonViewFactory(messenger: registrar.messenger())
    registrar.register(popupMenuFactory, withId: "CupertinoNativePopupMenuButton")

    let buttonFactory = CupertinoButtonViewFactory(messenger: registrar.messenger())
    registrar.register(buttonFactory, withId: "CupertinoNativeButton")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "showAlert":
      handleShowAlert(call: call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleShowAlert(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for showAlert", details: nil))
      return
    }

    let title = args["title"] as? String
    let message = args["message"] as? String

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    if let textFields = args["textFields"] as? [[String: Any]] {
      for textFieldData in textFields {
        alertController.addTextField { textField in
          if let placeholder = textFieldData["placeholder"] as? String {
            textField.placeholder = placeholder
          }
          if let text = textFieldData["text"] as? String {
            textField.text = text
          }
          if let secureTextEntry = textFieldData["secureTextEntry"] as? Bool {
            textField.isSecureTextEntry = secureTextEntry
          }
        }
      }
    }

    if let actionsData = args["actions"] as? [[String: Any]] {
      for (index, actionData) in actionsData.enumerated() {
        let title = actionData["title"] as? String ?? ""
        var style: UIAlertAction.Style = .default
        if let styleString = actionData["style"] as? String {
          if styleString == "destructive" {
            style = .destructive
          } else if styleString == "cancel" {
            style = .cancel
          }
        }

        let action = UIAlertAction(title: title, style: style) { [weak alertController] _ in
          var textFieldsValues: [String] = []
          if let fields = alertController?.textFields {
            for field in fields {
              textFieldsValues.append(field.text ?? "")
            }
          }
          let response: [String: Any] = [
            "actionIndex": index,
            "textFields": textFieldsValues
          ]
          result(response)
        }

        if let isEnabled = actionData["isEnabled"] as? Bool {
          action.isEnabled = isEnabled
        }

        alertController.addAction(action)
      }
    }

    guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
      result(FlutterError(code: "NO_ROOT_VIEW_CONTROLLER", message: "Could not find root view controller", details: nil))
      return
    }

    var topController = rootViewController
    while let presented = topController.presentedViewController {
        topController = presented
    }

    topController.present(alertController, animated: true, completion: nil)
  }
}
 
