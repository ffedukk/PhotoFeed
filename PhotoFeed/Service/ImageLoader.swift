//
//  ImageLoader.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 06.06.2024.
//

import UIKit

final class ImageLoader: Sendable {

    private let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    var image: UIImage? {
        get async throws {
            guard let url = URL(string: urlString) else { throw NetworkService.NetworkError.invalidURL }
            if let cachedImage = await ImageCache.shared.image(from: url) { return cachedImage }

            // Загружаем +2 секунду
            try await Task.sleep(for: .seconds(2))

            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            cache(image: image, for: url, cost: data)
            return image
        }
    }

    var loadingImageStream: AsyncThrowingStream<LoadingState, Error> {
        get {
            AsyncThrowingStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
                let task = Task { await loadImageWithProgress(progressContinuation: continuation) }
                continuation.onTermination = { @Sendable status in
                    task.cancel()
                    print("loadingImageStream terminated with status \(status)")
                }
            }
        }
    }
}

private extension ImageLoader {

    func loadImageWithProgress(progressContinuation: AsyncThrowingStream<LoadingState, Error>.Continuation) async {
        do {
            guard let url = URL(string: urlString) else { throw NetworkService.NetworkError.invalidURL }
            if let cachedImage = await ImageCache.shared.image(from: url) {
                progressContinuation.yield(.loaded(image: cachedImage))
                progressContinuation.finish()
                return
            }
            let (stream, response) = try await URLSession.shared.bytes(from: url)
            var bytes: [UInt8] = []
            for try await byte in stream {

                // Замедляем загрузку
                try await Task.sleep(for: .milliseconds(0.3))

                bytes.append(byte)
                let currentPercent = Int(Double(bytes.count) / Double(response.expectedContentLength) * 100.0)
                progressContinuation.yield(.loading(percent: currentPercent))
            }
            let data = Data(bytes)
            let image = UIImage(data: data)
            progressContinuation.yield(.loaded(image: image))
            progressContinuation.finish()
            cache(image: image, for: url, cost: data)
        } catch let error {
            progressContinuation.finish(throwing: error)
        }
    }

    func cache(image: UIImage?, for url: URL, cost data: Data) {
        Task.detached {
            if let image {

                // Кешируем +3 секунды
                try await Task.sleep(for: .seconds(3))

                await ImageCache.shared.insert(image: image, for: url, cost: data.count)
            }
        }
    }
}

extension ImageLoader {

    enum LoadingState {
        case loading(percent: Int)
        case loaded(image: UIImage?)
    }
}
