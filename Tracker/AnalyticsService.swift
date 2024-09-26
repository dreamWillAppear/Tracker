import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "ab7eae46-2637-4a84-8f83-7833e43e7cac") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func reportEvent(event: String, screen: String, item: String? = nil) {
            var params: [AnyHashable: Any] = ["event": event, "screen": screen]
            if let item = item {
                params["item"] = item
            }
            YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
                print("REPORT ERROR: \(error.localizedDescription)")
            })
        }
    
    func trackOpenScreen(screen: String) {
        reportEvent(event: "open", screen: screen)
    }
    
    func trackCloseScreen(screen: String) {
        reportEvent(event: "close", screen: screen)
    }
    
    func trackClick(screen: String, item: String) {
        reportEvent(event: "click", screen: screen, item: item)
    }
}
