//
//  Array+AsyncMap.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 13.06.2024.
//

extension Array where Element: Sendable {

    func asyncMap<T: Sendable>(_ transform: @escaping @Sendable (Element) async throws -> T ) async rethrows -> [T] {
        return try await withThrowingTaskGroup(of: (index: Int, newElement: T).self) { group -> [T] in
            var transformedArray: [T?] = Array<T?>(repeating: nil, count: self.count)
            for (index, element) in self.enumerated() {
                group.addTask { try await (index, transform(element)) }
            }
            for try await (index, transformedElement) in group {
                transformedArray[index] = transformedElement
            }
            return transformedArray.compactMap { $0 }
        }
    }
}
