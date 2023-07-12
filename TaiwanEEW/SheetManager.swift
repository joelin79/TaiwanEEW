//
//  SheetManager.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/6/8.
//

import Foundation

// No longer in use

final class SheetManager: ObservableObject {
    
    enum Action {
        case na, present, dismiss
    }
    
    @Published private(set) var action: Action = .present
    
    func present() {
        guard !action.isPresented else { return }
        self.action = .present
    }
    
    func dismiss() {
        self.action = .dismiss
    }
}

extension SheetManager.Action {
    var isPresented: Bool { self == .present }
}
