// -------------------------------------------------------------
// Core/Utils/Animations/ConfettiView.swift – CAEmitterLayer
// -------------------------------------------------------------
import SwiftUI
import UIKit

final class ConfettiUIView: UIView {
    private let emitter = CAEmitterLayer()
    override class var layerClass: AnyClass { CAEmitterLayer.self }
    override init(frame: CGRect) { super.init(frame: frame); setup() }
    required init?(coder: NSCoder) { fatalError() }
    private func setup() {
        let l = self.layer as! CAEmitterLayer
        l.emitterPosition = CGPoint(x: bounds.midX, y: -10)
        l.emitterShape = .line
        l.emitterSize = CGSize(width: bounds.width, height: 1)
        emitter.birthRate = 0
    }
    override func layoutSubviews() { super.layoutSubviews(); (layer as? CAEmitterLayer)?.emitterPosition = CGPoint(x: bounds.midX, y: -10); (layer as? CAEmitterLayer)?.emitterSize = CGSize(width: bounds.width, height: 1) }

    func burst() {
        let colors: [UIColor] = [.systemPink, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
        var cells: [CAEmitterCell] = []
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 8
            cell.lifetime = 5
            cell.velocity = 200
            cell.velocityRange = 80
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi/4
            cell.spin = 2
            cell.scale = 0.6
            cell.color = color.cgColor
            cell.contents = UIImage(systemName: "circle.fill")?.withTintColor(color, renderingMode: .alwaysOriginal).cgImage
            cells.append(cell)
        }
        let l = (layer as! CAEmitterLayer)
        l.emitterCells = cells
        l.beginTime = CACurrentMediaTime()
        l.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { l.birthRate = 0 }
    }
}

struct ConfettiView: UIViewRepresentable {
    class Coordinator { let view = ConfettiUIView() }
    func makeCoordinator() -> Coordinator { Coordinator() }
    func makeUIView(context: Context) -> ConfettiUIView { context.coordinator.view }
    func updateUIView(_ uiView: ConfettiUIView, context: Context) {}
    static func trigger(_ coordinator: Coordinator) { coordinator.view.burst() }
}
