import UIKit

final class StatisticsFactory {
    
    //MARK: - Public Properties
    
    static let shared = StatisticsFactory()
    
    private init() {
        updateStatistics()
    }
    
    var statisticsDidUpdated: (() -> Void)?
    
    lazy var allRecordsCount: Int = 0
    lazy var perfectDaysCount: Int =  0
    lazy var longestPerfectStreak: Int = 0
    lazy var averageValue: Int = 0
    
    //MARK: - Private Properties
    
    private let trackersFactory = TrackersFactory.shared
    private let perfectDaysKey = "perfectDaysCount"
    
    //MARK: - Public Methods
    
    func updateStatistics() {
        allRecordsCount = trackersFactory.getAllRecordsCount()
        perfectDaysCount = trackersFactory.getPerfectDays().count
        longestPerfectStreak = trackersFactory.getLongestPerfectStreak(from: trackersFactory.getPerfectDays())
        averageValue = (perfectDaysCount != 0) ? allRecordsCount / perfectDaysCount : 0
        statisticsDidUpdated?()
    }
    
}
