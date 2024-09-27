import Foundation

enum Localizable: String {
    case tabBarTrackersButton = "tabBar.trackersButton"
    case tabBarStatisticsButton = "tabBar.statisticsButton"
    case trackersViewControllerMainTitle = "trackersViewController.mainTitle"
    case trackersViewControllerFilterButtonTitle = "trackersViewController.filterButtonTitle"
    case  trackerCellCounterLabelOneDay = "trackerCell.counterLabel.oneDay"
    case  trackerCellCounterLabelSeveralDays = "trackerCell.counterLabel.severalDays"
    case trackerCellCounterLabelRu_dnya = "trackerCell.counterLabel.ru_dnya"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
