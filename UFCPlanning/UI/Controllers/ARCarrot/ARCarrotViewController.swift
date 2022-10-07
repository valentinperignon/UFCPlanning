//
//  ArCarrotViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 06/10/2022.
//

import RealityKit
import UIKit

class ARCarrotViewController: UIViewController {
    private var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemSymbol: .xmark),
            style: .done,
            target: self,
            action: #selector(closeViewController)
        )

        arView = ARView(frame: view.bounds)
        view.addSubview(arView)

        addElement()
    }

    @objc private func closeViewController() {
        dismiss(animated: true)
    }

    private func addElement() {
        let anchor = AnchorEntity()
        anchor.position = simd_make_float3(0, 0, 0)

        if let usdzModel = try? Entity.load(named: "carrot") {
            anchor.addChild(usdzModel)
        }
        arView.scene.anchors.append(anchor)
    }

    static func instantiateInNavigationController() -> UINavigationController {
        let vc = UINavigationController(rootViewController: ARCarrotViewController())
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
