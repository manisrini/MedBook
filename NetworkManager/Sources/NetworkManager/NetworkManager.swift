// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@MainActor
public class NetworkManager{
    
    public static let shared = NetworkManager()
    
    public func getData(urlStr: String) async -> (Data?, String?) {
         guard let url = URL(string: urlStr) else {
             return (nil, "Invalid URL")
         }
         
         let request = URLRequest(url: url)
         
         do {
             let (data, _) = try await URLSession.shared.data(for: request)
             return (data, nil)
         } catch {
             return (nil, error.localizedDescription)
         }
     }
    
}
