//
//  MainView.swift
//  Avengers
//
//  Created by khoa on 01/11/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    @State private var isDetecting: Bool = false
    @State private var result: String?
    @Environment(\.presentationMode) private var presentationMode
    private let detector = Detector()

    var body: some View {
        VStack {
            makeImage()
                .styleFit()

            if isDetecting {
                ActivityIndicator(
                    isAnimating: $isDetecting,
                    style: .large
                )
            }

            makeResult()

            Button(action: {
                self.showImagePicker.toggle()
            }, label: {
                Text("Choose image")
            })
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(image: self.$image, isPresented: self.$showImagePicker)
            })
        }
    }

    private func makeImage() -> Image {
        if let image = self.image {
            self.isDetecting = true
            try? self.detector.detect(image: image, completion: { result in
                switch result {
                case .success(let string):
                    self.result = string
                default:
                    self.result = ""
                }

                self.isDetecting = false

            })

            return Image(uiImage: image)
        } else {
            return Image("placeholder")
        }
    }

    private func makeResult() -> Text {
        if let result = result {
            return Text(result)
        } else {
            return Text("")
        }
    }
}

extension Image {
    func styleFit() -> some View {
        return self
            .resizable()
            .frame(width: 300, height: 300, alignment: .center)
    }
}
