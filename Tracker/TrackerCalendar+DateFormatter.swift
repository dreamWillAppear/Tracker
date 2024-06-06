import Foundation


enum TrackerCalendar  {
    static let currentCalendar = Calendar.current
    static let currentDayweek = currentCalendar.component(.weekday, from: Date())
    static let currentDayweekIndex  = (currentDayweek + 5) % 7
}

enum TrackerDateFormatter  {
    static let dateFormatter = DateFormatter()
}


