//
//  MainView.swift
//  Avengers
//
//  Created by khoa on 01/11/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var showImagePicker: Bool = false
    @State var image: UIImage? = nil

    var body: some View {
        VStack {
            makeImage()
                .styleFit()

            Button(action: {
                self.showImagePicker.toggle()
            }, label: {
                Text("Choose image")
            })
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(image: self.$image)
            })
        }
    }

    private func makeImage() -> Image {
        if let image = self.image {
            return Image(uiImage: image)
        } else {
            return Image("placeholder")
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
