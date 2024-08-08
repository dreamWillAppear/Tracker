import Foundation

enum TrackerCalendar {
    static let currentCalendar = Calendar.current
    static let currentDayWeek = currentCalendar.component(.weekday, from: Date())
    static let currentDayWeekIndex = (currentDayWeek + 5) % 7
    static var currentDate: Date {
        return currentCalendar.startOfDay(for: Date())
    }
}
