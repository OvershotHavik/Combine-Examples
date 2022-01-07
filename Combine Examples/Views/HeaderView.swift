//
//  HeaderView.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/7/22.
//

import SwiftUI

struct DescView: View {
    var desc : String
    var back = Color.blue
    var textColor = Color.primary
    
    var body: some View {
        Text(desc)
            .frame(maxWidth: .infinity)
            .padding()
            .background(back)
            .foregroundColor(textColor)
            .font(.title)
    }
}

struct DescView_Previews: PreviewProvider {
    static var previews: some View {
        DescView(desc: "Testing")
    }
}
