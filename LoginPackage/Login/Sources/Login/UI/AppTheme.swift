//
//  File.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//
import SwiftUI
import Utilities
import DesignSystem

struct AppThemeView : View {
    var body: some View {
        Color(uiColor: Utilities.hexStringToUIColor(hex: DSMColorTokens.AppTheme.rawValue))
    }
}

