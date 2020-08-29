//
//  Helpers.swift
//  BookSpine
//
//  Created by Chris Bearden on 8/15/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import SwiftUI

let screen = UIScreen.main.bounds

enum InputError: Error {
    case empty
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
