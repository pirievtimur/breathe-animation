import Foundation

protocol BreathePhasesProviderProtocol {
    func phases() -> [BreathePhase]?
}

class BreathePhasesProvider: BreathePhasesProviderProtocol {
    func phases() -> [BreathePhase]? {
        guard let filePath = Bundle.main.path(forResource: "phases", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
        
        do {
            let parsedResult = try JSONDecoder().decode([BreathePhase].self, from: data)
            return parsedResult
        } catch {
            fatalError("check json file")
        }
    }
}
