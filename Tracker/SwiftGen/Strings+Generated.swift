// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Эта категория точно не нужна?
  internal static let alertMessage = L10n.tr("Localizable", "alertMessage", fallback: "Эта категория точно не нужна?")
  /// Все трекеры
  internal static let allTrackers = L10n.tr("Localizable", "allTrackers", fallback: "Все трекеры")
  /// Среднее значение
  internal static let averageValue = L10n.tr("Localizable", "averageValue", fallback: "Среднее значение")
  /// Лучший период
  internal static let bestPeriod = L10n.tr("Localizable", "bestPeriod", fallback: "Лучший период")
  /// Отмена
  internal static let cancelAlertButtonText = L10n.tr("Localizable", "cancelAlertButtonText", fallback: "Отмена")
  /// Отменить
  internal static let cancelButtonText = L10n.tr("Localizable", "cancelButtonText", fallback: "Отменить")
  /// Введите название категории
  internal static let categoryCreateTextFieldPlaceholderText = L10n.tr("Localizable", "categoryCreateTextFieldPlaceholderText", fallback: "Введите название категории")
  /// Новая категория
  internal static let categoryCreateTitleText = L10n.tr("Localizable", "categoryCreateTitleText", fallback: "Новая категория")
  /// Введите название категории
  internal static let categoryEditTextFieldPlaceholderText = L10n.tr("Localizable", "categoryEditTextFieldPlaceholderText", fallback: "Введите название категории")
  /// Редактирование категории
  internal static let categoryEditTitleText = L10n.tr("Localizable", "categoryEditTitleText", fallback: "Редактирование категории")
  /// Категория
  internal static let categoryListTitle = L10n.tr("Localizable", "categoryListTitle", fallback: "Категория")
  /// Категория
  internal static let categorySelectMenu = L10n.tr("Localizable", "categorySelectMenu", fallback: "Категория")
  /// Цвет
  internal static let colorSelectMenu = L10n.tr("Localizable", "colorSelectMenu", fallback: "Цвет")
  /// Завершенные
  internal static let completedTrackers = L10n.tr("Localizable", "completedTrackers", fallback: "Завершенные")
  /// Готово
  internal static let confirmCreateButtonText = L10n.tr("Localizable", "confirmCreateButtonText", fallback: "Готово")
  /// Готово
  internal static let confirmEditButtonText = L10n.tr("Localizable", "confirmEditButtonText", fallback: "Готово")
  /// Готово
  internal static let confirmScheduleButtonText = L10n.tr("Localizable", "confirmScheduleButtonText", fallback: "Готово")
  /// Создать
  internal static let createButtonText = L10n.tr("Localizable", "createButtonText", fallback: "Создать")
  /// Добавить категорию
  internal static let createCategoryButtonText = L10n.tr("Localizable", "createCategoryButtonText", fallback: "Добавить категорию")
  /// Удалить
  internal static let deleteAlertButtonText = L10n.tr("Localizable", "deleteAlertButtonText", fallback: "Удалить")
  /// Удалить
  internal static let deleteCategory = L10n.tr("Localizable", "deleteCategory", fallback: "Удалить")
  /// Удалить
  internal static let deletText = L10n.tr("Localizable", "deletText", fallback: "Удалить")
  /// Редактировать
  internal static let editCategory = L10n.tr("Localizable", "editCategory", fallback: "Редактировать")
  /// Редактировать
  internal static let editText = L10n.tr("Localizable", "editText", fallback: "Редактировать")
  /// Emoji
  internal static let emojiSelectMenu = L10n.tr("Localizable", "emojiSelectMenu", fallback: "Emoji")
  /// Анализировать пока нечего
  internal static let emtyStatisticsText = L10n.tr("Localizable", "emtyStatisticsText", fallback: "Анализировать пока нечего")
  /// Что будем отслеживать?
  internal static let emtyTrackerPlaceholderText = L10n.tr("Localizable", "emtyTrackerPlaceholderText", fallback: "Что будем отслеживать?")
  /// Фильтры
  internal static let filterButtonText = L10n.tr("Localizable", "filterButtonText", fallback: "Фильтры")
  /// Фильтры
  internal static let filterTitle = L10n.tr("Localizable", "filterTitle", fallback: "Фильтры")
  /// Пт
  internal static let fri = L10n.tr("Localizable", "Fri", fallback: "Пт")
  /// Пятница
  internal static let friday = L10n.tr("Localizable", "Friday", fallback: "Пятница")
  /// Привычка
  internal static let habbitButtonText = L10n.tr("Localizable", "habbitButtonText", fallback: "Привычка")
  /// Пн
  internal static let mon = L10n.tr("Localizable", "Mon", fallback: "Пн")
  /// Понедельник
  internal static let monday = L10n.tr("Localizable", "Monday", fallback: "Понедельник")
  /// Не завершенные
  internal static let notCompletedTracker = L10n.tr("Localizable", "notCompletedTracker", fallback: "Не завершенные")
  /// Ничего не найдено
  internal static let notFoundTrackerPlaceholderText = L10n.tr("Localizable", "notFoundTrackerPlaceholderText", fallback: "Ничего не найдено")
  /// Нерегулярное событие
  internal static let notRegularButtonText = L10n.tr("Localizable", "notRegularButtonText", fallback: "Нерегулярное событие")
  /// Редактирование нерегулярного события
  internal static let notRegularTrackerEditTitle = L10n.tr("Localizable", "notRegularTrackerEditTitle", fallback: "Редактирование нерегулярного события")
  /// Новое нерегулярное событие
  internal static let notRegularTrackerTitle = L10n.tr("Localizable", "notRegularTrackerTitle", fallback: "Новое нерегулярное событие")
  /// Plural format key: "%#@days@"
  internal static func numberOfDays(_ p1: Int) -> String {
    return L10n.tr("Localizable", "numberOfDays", p1, fallback: "Plural format key: \"%#@days@\"")
  }
  /// Localizable.strings
  ///   Tracker
  /// 
  ///   Created by Федор Завьялов on 02.09.2024.
  internal static let pageOneText = L10n.tr("Localizable", "pageOneText", fallback: "Отслеживайте только то, что хотите")
  /// Даже если это не литры воды и йога
  internal static let pageTwoText = L10n.tr("Localizable", "pageTwoText", fallback: "Даже если это не литры воды и йога")
  /// Идеальные дни
  internal static let perfectDays = L10n.tr("Localizable", "perfectDays", fallback: "Идеальные дни")
  /// Закрепленные
  internal static let pinHeaderText = L10n.tr("Localizable", "pinHeaderText", fallback: "Закрепленные")
  /// Закрепить
  internal static let pinText = L10n.tr("Localizable", "pinText", fallback: "Закрепить")
  /// Редактирование привычки
  internal static let regularTrackerEditTitle = L10n.tr("Localizable", "regularTrackerEditTitle", fallback: "Редактирование привычки")
  /// Новая привычка
  internal static let regularTrackerTitle = L10n.tr("Localizable", "regularTrackerTitle", fallback: "Новая привычка")
  /// Сб
  internal static let sat = L10n.tr("Localizable", "Sat", fallback: "Сб")
  /// Суббота
  internal static let saturday = L10n.tr("Localizable", "Saturday", fallback: "Суббота")
  /// Сохранить
  internal static let saveButtonText = L10n.tr("Localizable", "saveButtonText", fallback: "Сохранить")
  /// Расписание
  internal static let scheduleSelectMenu = L10n.tr("Localizable", "scheduleSelectMenu", fallback: "Расписание")
  /// Расписание
  internal static let scheduleTitle = L10n.tr("Localizable", "scheduleTitle", fallback: "Расписание")
  /// Поиск
  internal static let searchFieldPlaceholder = L10n.tr("Localizable", "searchFieldPlaceholder", fallback: "Поиск")
  /// Вот это технологии!
  internal static let startButtonText = L10n.tr("Localizable", "startButtonText", fallback: "Вот это технологии!")
  /// Статистика
  internal static let statistic = L10n.tr("Localizable", "statistic", fallback: "Статистика")
  /// Статистика
  internal static let statisticMainLable = L10n.tr("Localizable", "statisticMainLable", fallback: "Статистика")
  /// Вс
  internal static let sun = L10n.tr("Localizable", "Sun", fallback: "Вс")
  /// Воскресенье
  internal static let sunday = L10n.tr("Localizable", "Sunday", fallback: "Воскресенье")
  /// Ограничение 38 символов
  internal static let textLimitMessage = L10n.tr("Localizable", "textLimitMessage", fallback: "Ограничение 38 символов")
  /// Чт
  internal static let thurs = L10n.tr("Localizable", "Thurs", fallback: "Чт")
  /// Четверг
  internal static let thursday = L10n.tr("Localizable", "Thursday", fallback: "Четверг")
  /// Трекеры на сегодня
  internal static let trackerForToday = L10n.tr("Localizable", "trackerForToday", fallback: "Трекеры на сегодня")
  /// Введите название трекера
  internal static let trackerNamePlaceholder = L10n.tr("Localizable", "trackerNamePlaceholder", fallback: "Введите название трекера")
  /// Трэкеры
  internal static let trackers = L10n.tr("Localizable", "trackers", fallback: "Трэкеры")
  /// Трекеров завершено
  internal static let trackersCompleted = L10n.tr("Localizable", "trackersCompleted", fallback: "Трекеров завершено")
  /// Создание трекера
  internal static let trackerTypeSelectTitle = L10n.tr("Localizable", "trackerTypeSelectTitle", fallback: "Создание трекера")
  /// Трэкеры
  internal static let trackMainLable = L10n.tr("Localizable", "trackMainLable", fallback: "Трэкеры")
  /// Вт
  internal static let tues = L10n.tr("Localizable", "Tues", fallback: "Вт")
  /// Вторник
  internal static let tuesday = L10n.tr("Localizable", "Tuesday", fallback: "Вторник")
  /// Открепить
  internal static let unpinText = L10n.tr("Localizable", "unpinText", fallback: "Открепить")
  /// Ср
  internal static let wed = L10n.tr("Localizable", "Wed", fallback: "Ср")
  /// Среда
  internal static let wednesday = L10n.tr("Localizable", "Wednesday", fallback: "Среда")
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
