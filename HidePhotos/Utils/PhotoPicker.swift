import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  @Binding var images: [UIImage]

  func makeUIViewController(context: Context) -> some UIViewController {
    // 1
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    // 2
    configuration.selectionLimit = 0
    // 3
    let picker =
      PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }

  func makeCoordinator() -> PhotosCoordinator {
    PhotosCoordinator(parent: self)
  }

  class PhotosCoordinator: NSObject,
    PHPickerViewControllerDelegate {
    var parent: PhotoPicker

    init(parent: PhotoPicker) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      let itemProviders = results.map(\.itemProvider)
      for item in itemProviders {
        // load the image from the item here
        // 1
        if item.canLoadObject(ofClass: UIImage.self) {
          // 2
          item.loadObject(ofClass: UIImage.self) { image, error in
            // 3
            if let error = error {
              print("Error!", error.localizedDescription)
            } else {
              // 4
              DispatchQueue.main.async {
                if let image = image as? UIImage {
                  self.parent.images.append(image)
                }
                 
              }
            }
          }
        }
      }
        self.parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
