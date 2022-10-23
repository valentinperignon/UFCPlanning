// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Action {
    internal enum Button {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "action.button.cancel", fallback: "Cancel")
      /// Ok
      internal static let ok = L10n.tr("Localizable", "action.button.ok", fallback: "Ok")
    }
  }
  internal enum Settings {
    /// Localizable.strings
    ///   UFCPlanning
    /// 
    ///   Created by Valentin Perignon on 23/10/2022.
    internal static let title = L10n.tr("Localizable", "settings.title", fallback: "Settings")
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
    }
    internal enum Options {
      internal enum EventAlarm {
        /// No alarm
        internal static let no = L10n.tr("Localizable", "settings.options.eventAlarm.no", fallback: "No alarm")
        /// 1 day before
        internal static let oneDay = L10n.tr("Localizable", "settings.options.eventAlarm.oneDay", fallback: "1 day before")
        /// 1 hour before
        internal static let oneHour = L10n.tr("Localizable", "settings.options.eventAlarm.oneHour", fallback: "1 hour before")
        /// 2 days before
        internal static let twoDays = L10n.tr("Localizable", "settings.options.eventAlarm.twoDays", fallback: "2 days before")
        /// 2 hours before
        internal static let twoHours = L10n.tr("Localizable", "settings.options.eventAlarm.twoHours", fallback: "2 hours before")
      }
      internal enum VisibilityDays {
        /// 1 month
        internal static let oneMonth = L10n.tr("Localizable", "settings.options.visibilityDays.oneMonth", fallback: "1 month")
        /// 1 week
        internal static let oneWeek = L10n.tr("Localizable", "settings.options.visibilityDays.oneWeek", fallback: "1 week")
        /// 2 months
        internal static let twoMonths = L10n.tr("Localizable", "settings.options.visibilityDays.twoMonths", fallback: "2 months")
        /// 2 weeks
        internal static let twoWeeks = L10n.tr("Localizable", "settings.options.visibilityDays.twoWeeks", fallback: "2 weeks")
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
