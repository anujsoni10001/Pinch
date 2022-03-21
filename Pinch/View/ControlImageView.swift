//
//  ControlImageView.swift
//  Pinch
//
//  Created by Anuj Soni on 21/03/22.
//

import SwiftUI

struct ControlImageView: View {
var symbolname:String
    
    var body: some View {
        Image(systemName:symbolname)
        .font(.system(size: 36))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(symbolname: "minus.magnifyingglass").preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
