//
//  ResizableContainer.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 14.06.2024.
//

import UIKit

final class ResizableContainer: UIControl {

    let duration: TimeInterval = 0.1

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            super.touchesBegan(touches, with: event)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: duration, delay: duration, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            super.touchesCancelled(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: duration, delay: duration, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            super.touchesEnded(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: duration, delay: duration, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            super.touchesMoved(touches, with: event)
        }
    }
}
