//
//  SaveToLIbrarySheet.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 05/08/22.
//

import Foundation


import SwiftUI

struct SaveToLibrarySheet: UIViewControllerRepresentable {
    
  let activityItems: [UIImage]
  let applicationActivities: [UIActivity]?

  func makeUIViewController(context: Context) -> some UIViewController {
    UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities)
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}
