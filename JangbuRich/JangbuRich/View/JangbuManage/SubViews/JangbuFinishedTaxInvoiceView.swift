//
//  JangbuFinishedTaxInvoiceView.swift
//  JangbuRich
//
//  Created by 변상우 on 12/6/24.
//

import SwiftUI

struct JangbuFinishedTaxInvoiceView: View {
    
    @EnvironmentObject var overlayManager: OverlayManager
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    overlayManager.hideSheet()
                } label: {
                    Image(.xButton)
                        .resizable()
                        .scaledToFit()
                        .frame(height: scaledHeight(24))
                }
            }
            .padding(.bottom, scaledHeight(20))
            
            VStack {
                Image(.iconFinish)
                    .resizable()
                    .scaledToFit()
                    .frame(height: scaledHeight(80))
                    .padding(.bottom, scaledHeight(25))
                
                Text("세금 계산서 발행 완료!")
                    .font(.headline6)
                    .foregroundStyle(.jgray20)
                    .padding(.bottom, scaledHeight(5))
                
                Text("바로빌에 연결된 이메일을 확인해주세요")
                    .font(.label1)
                    .foregroundStyle(.jgray40)
            }
            .padding(.bottom, scaledHeight(40))
            
            Button {
                overlayManager.hideSheet()
            } label: {
                Text("확인")
                    .font(.label1)
                    .foregroundStyle(.jgray100)
                    .padding(.horizontal, scaledWidth(185))
                    .padding(.vertical, scaledHeight(12))
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: scaledHeight(10))
                            .fill(.jgray20)
                    )
            }
        }
        .padding(scaledWidth(20))
    }
}
