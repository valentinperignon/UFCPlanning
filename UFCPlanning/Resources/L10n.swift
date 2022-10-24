// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// InfoPlist.strings
    ///   UFCPlanning
    /// 
    ///   Created by Valentin Perignon on 24/10/2022.
    internal static let nsCalendarsUsageDescription = L10n.tr("InfoPlist", "NSCalendarsUsageDescription", fallback: "We need to access to your calendar so that you can save your assignments.")
  }
  internal enum Localizable {
    internal enum Action {
      internal enum Button {
        /// Cancel
        internal static let cancel = L10n.tr("Localizable", "action.button.cancel", fallback: "Cancel")
        /// Ok
        internal static let confirm = L10n.tr("Localizable", "action.button.confirm", fallback: "Ok")
        /// Ok
        internal static let ok = L10n.tr("Localizable", "action.button.ok", fallback: "Ok")
      }
    }
    internal enum Home {
      /// Search
      internal static let search = L10n.tr("Localizable", "home.search", fallback: "Search")
      /// Localizable.strings
      ///   UFCPlanning
      /// 
      ///   Created by Valentin Perignon on 23/10/2022.
      internal static let title = L10n.tr("Localizable", "home.title", fallback: "Schedule")
    }
    internal enum Settings {
      /// Settings
      internal static let title = L10n.tr("Localizable", "settings.title", fallback: "Settings")
      internal enum Account {
        /// Log out
        internal static let button = L10n.tr("Localizable", "settings.account.button", fallback: "Log out")
        /// Do you want to log out?
        internal static let message = L10n.tr("Localizable", "settings.account.message", fallback: "Do you want to log out?")
        /// My Account
        internal static let title = L10n.tr("Localizable", "settings.account.title", fallback: "My Account")
      }
      internal enum Groups {
        /// All groups
        internal static let title = L10n.tr("Localizable", "settings.groups.title", fallback: "All groups")
      }
      internal enum Login {
        /// Login
        internal static let login = L10n.tr("Localizable", "settings.login.login", fallback: "Login")
        /// Password
        internal static let password = L10n.tr("Localizable", "settings.login.password", fallback: "Password")
        /// Log in
        internal static let title = L10n.tr("Localizable", "settings.login.title", fallback: "Log in")
        internal enum Error {
          /// Wrong login or password
          internal static let message = L10n.tr("Localizable", "settings.login.error.message", fallback: "Wrong login or password")
          /// Error
          internal static let title = L10n.tr("Localizable", "settings.login.error.title", fallback: "Error")
        }
      }
      internal enum Row {
        /// Add a group
        internal static let addGroup = L10n.tr("Localizable", "settings.row.addGroup", fallback: "Add a group")
        /// Campus Sport Activities
        internal static let campus = L10n.tr("Localizable", "settings.row.campus", fallback: "Campus Sport Activities")
        /// Homework alerts
        internal static let homework = L10n.tr("Localizable", "settings.row.homework", fallback: "Homework alerts")
        /// Log In
        internal static let login = L10n.tr("Localizable", "settings.row.login", fallback: "Log In")
        /// Number of days to display
        internal static let numberOfDays = L10n.tr("Localizable", "settings.row.numberOfDays", fallback: "Number of days to display")
      }
    }
    internal enum Widget {
      /// Display my next class.
      internal static let description = L10n.tr("Localizable", "widget.description", fallback: "Display my next class.")
      /// My Next Class
      internal static let title = L10n.tr("Localizable", "widget.title", fallback: "My Next Class")
      /// Tomorrow at %@
      internal static func tomorrow(_ p1: Any) -> String {
        return L10n.tr("Localizable", "widget.tomorrow", String(describing: p1), fallback: "Tomorrow at %@")
      }
      internal enum Error {
        /// No upcoming classes
        internal static let empty = L10n.tr("Localizable", "widget.error.empty", fallback: "No upcoming classes")
        /// Error
        internal static let general = L10n.tr("Localizable", "widget.error.general", fallback: "Error")
        /// Network error
        internal static let network = L10n.tr("Localizable", "widget.error.network", fallback: "Network error")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
