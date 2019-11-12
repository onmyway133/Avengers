//
//  MainView.swift
//  Avengers
//
//  Created by khoa on 01/11/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import SwiftUI
import Combine

struct ViewModel {
    var imagePublisher = PassthroughSubject<UIImage?, Never>()
    var image: UIImage? {
        didSet {
            imagePublisher.send(image)
        }
    }
    var isDetecting: Bool = false
    var result: String?
}

struct MainView: View {
    @State private var showImagePicker: Bool = false
    @State private var viewModel: ViewModel = ViewModel()

    private let detector = Detector()

    var body: some View {
        VStack {
            makeImage()
                .styleFit()

            if viewModel.isDetecting {
                ActivityIndicator(
                    isAnimating: $viewModel.isDetecting,
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
                ImagePicker(image: self.$viewModel.image, isPresented: self.$showImagePicker)
            })
        }
        .onReceive(viewModel.imagePublisher, perform: { image in
            if let image = image {
                self.detect(image: image)
            }
        })
    }

    private func makeImage() -> Image {
        if let image = self.viewModel.image {
            return Image(uiImage: image)
        } else {
            return Image("placeholder")
        }
    }

    private func makeResult() -> Text {
        if let result = viewModel.result {
            return Text(result)
        } else {
            return Text("")
        }
    }

    private func detect(image: UIImage) {
        viewModel.isDetecting = true
        try? detector.detect(image: image, completion: { result in
            switch result {
            case .success(let string):
                self.viewModel.result = string
            default:
                self.viewModel.result = ""
            }

            self.viewModel.isDetecting = false
        })
    }
}

extension Image {
    func styleFit() -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300, alignment: .center)
    }
}
