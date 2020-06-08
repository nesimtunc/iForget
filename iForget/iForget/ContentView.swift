//
//  ContentView.swift
//  iForget
//
//  Created by Neso on 2020/06/08.
//  Copyright © 2020 Rainlab. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	@State var message = UserDefaults.standard.string(forKey: "message") ?? ""
	@State var result = ""

	private let session = SessionController()

    var body: some View {
		VStack {
			Form {
				Section (header: Text("Message")
					.font(Font.system(size: 50, weight: .medium, design: .rounded))
					, content: {

						// Two way binding $message
						TextField("Your message", text: self.$message)
							.frame(minWidth: 320, maxWidth: .infinity, minHeight: 100, alignment: .topLeading)

						Button("Save",
							   action: {
								// let's save it in UserDefaults
								UserDefaults.self.standard.setValue(self.message, forKey: "message")
								self.result = "Saved!"

						}).font(.largeTitle)
							.padding(.top, 16)
							.padding(.bottom, 16)
				})

			}.frame(minWidth: 320, maxWidth: .infinity, minHeight: 250, maxHeight: 250, alignment: .topLeading)

			Text(self.result)
			Spacer()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
