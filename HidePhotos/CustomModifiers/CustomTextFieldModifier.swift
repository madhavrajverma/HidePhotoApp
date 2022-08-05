//
//  CustomTextFieldModifier.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import SwiftUI

struct CustomTextFieldModifier: ViewModifier {
    let height:CGFloat
    let borderColor:Color
    init(height:CGFloat = 28, borderColor: Color = Color.blue) {
        self.height = height
        self.borderColor = borderColor
    }
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height:28)
            .frame(maxWidth:.infinity)
            .padding()
            .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor,lineWidth: 2)
               
            )
    }
}
