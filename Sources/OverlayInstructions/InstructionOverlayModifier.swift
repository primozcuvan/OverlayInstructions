//
//  InstructionOverlayModifier.swift
//
//
//  Created by Primoz Cuvan on 15. 09. 24.
//

import SwiftUI

// Modifier to capture the frame for a specific InstructionType
struct InstructionOverlayModifier<InstructionType: InstructionOverlayType>: ViewModifier {
    
    @EnvironmentObject var frameCollector: OverlayInstructionsManager<InstructionType>
    
    var instructionType: InstructionType
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.onAppear {
                        let frame = geometry.frame(in: .global)
                        // Collect the frame for the current instruction type
                        frameCollector.addFrame(for: instructionType, frame: frame)
                    }
                    .onChange(of: geometry.frame(in: .global)) { _, newFrame in
                        // Collect the frame for the current instruction type
                        frameCollector.addFrame(for: instructionType, frame: newFrame)
                    }
                }
            )
    }
}

// View extension to easily apply the InstructionOverlayModifier
public extension View {
    func instructionOverlayType<InstructionType: InstructionOverlayType>(_ instructionType: InstructionType) -> some View {
        self.modifier(InstructionOverlayModifier(instructionType: instructionType))
    }
}
