//
//  SwiftUIView.swift
//  WaterMap
//
//  Created by 游宗諭 on 2019/12/8.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
	private var viewModel = WaterMapViewModel.shared
	var body: some View {
		MapView().edgesIgnoringSafeArea(.vertical)
		
    }
	 func loadOverPass() {
	
	}
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
		ZStack {
        ContentView()
			.edgesIgnoringSafeArea(.all)
		}
    }
}
