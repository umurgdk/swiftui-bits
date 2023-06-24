//  Created by Umur Gedik on 24.06.2023.

import Foundation
import UIKit
import Metal

class MUIResourceManager {
    let meshVertexBuffer: MUITypedBuffer<MUIVertex>
    let meshIndexBuffer: MUITypedBuffer<UInt32>
    let instanceBuffer: MUITypedBuffer<MUINode>

    let device: MTLDevice

    init(device: MTLDevice) {
        self.device = device
        
        self.meshVertexBuffer = MUITypedBuffer(device: device, with: RectangleMesh.quad.vertices)
        self.meshIndexBuffer = MUITypedBuffer(device: device, with: RectangleMesh.quad.indices)
        self.instanceBuffer = MUITypedBuffer(device: device, count: 100, options: .storageModeShared)
    }

    func setViews(_ views: [MUIHierarchyNode], images: [AnyHashable: UIImage]) {

    }
}
