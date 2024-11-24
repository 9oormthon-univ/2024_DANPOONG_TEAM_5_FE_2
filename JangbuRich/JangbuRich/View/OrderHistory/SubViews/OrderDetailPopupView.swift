//
//  OrderDetailPopupView.swift
//  JangbuRich
//
//  Created by 변상우 on 11/21/24.
//

import SwiftUI

struct OrderDetailPopupView: View {
    
    @EnvironmentObject var overlayManager: OverlayManager
    
    let orderDetail: OrderDetailResult
    
    var body: some View {
        VStack {
            HStack {
                Text("주문 내역")
                    .font(.body6)
                    .foregroundStyle(.jgray20)
                
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
            .padding(.bottom, scaledHeight(25))
            
            VStack(spacing: scaledHeight(20)) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: scaledWidth(8))
                            .stroke(lineWidth: scaledWidth(2))
                            .fill(.jOrange)
                        
                        Text("\(orderDetail.id)")
                            .font(.body2)
                            .foregroundStyle(.jOrange)
                    }
                    .frame(width: scaledWidth(27), height: scaledHeight(27))
                    .padding(.trailing, scaledWidth(10))
                    
                    Text(orderDetail.teamName)
                        .font(.detail2)
                        .foregroundStyle(.jgray20)
                    
                    Text("|")
                        .font(.body4)
                        .foregroundStyle(.jgray60)
                        .padding(.horizontal, scaledWidth(5))
                    
                    Text(orderDetail.teamUserName)
                        .font(.detail2)
                        .foregroundStyle(.jgray20)
                    
                    Spacer()
                }
                .padding(.bottom, scaledHeight(25))
                
                Rectangle()
                    .fill(.jgray80)
                    .frame(height: scaledHeight(1))
                
                VStack(spacing: scaledWidth(20)) {
                    ForEach(orderDetail.menus, id: \.menuName) { menu in
                        HStack {
                            Text(menu.menuName)
                                .font(.body2)
                                .foregroundStyle(.jgray30)
                            
                            Spacer()
                            
                            Text("\(menu.amount)")
                                .font(.body1)
                                .foregroundStyle(.jgray20)
                                .padding(.trailing, scaledWidth(5))
                            
                            Text("개")
                                .font(.detail1)
                                .foregroundStyle(.jgray50)
                        }
                    }
                }
                
                VStack {
                    VStack {
                        HStack {
                            Text(formatDate(orderDetail.dateTime))
                                .font(.detail1)
                                .foregroundStyle(.jgray50)
                            
//                            Text("|")
//                                .font(.detail4)
//                                .foregroundStyle(.jgray70)
//                            
//                            Text(formatDate(orderDetail.dateTime))
//                                .font(.detail1)
//                                .foregroundStyle(.jgray50)
//                            
                            Spacer()
                            
                            Text("총 \(orderDetail.amount)개")
                                .font(.detail1)
                                .foregroundStyle(.jgray20)
                        }
                        
                        Rectangle()
                            .fill(.jgray80)
                            .frame(height: scaledHeight(1))
                            .padding(.vertical, scaledHeight(15))
                        
                        HStack {
                            Text("합계 금액")
                                .font(.detail2)
                                .foregroundStyle(.jgray20)
                            
                            Spacer()
                        }
                        .padding(.bottom, scaledHeight(15))
                        
                        HStack {
                            Text("상품 금액")
                                .font(.detail1)
                                .foregroundStyle(.jgray50)
                            
                            Spacer()
                            
                            Text("\(orderDetail.totalPrice)")
                                .font(.body2)
                                .foregroundStyle(.jgray30)
                        }
                        .padding(.bottom, scaledHeight(10))
                        
                        HStack {
                            Text("할인 금액")
                                .font(.detail1)
                                .foregroundStyle(.jgray50)
                            
                            Spacer()
                            
                            Text("0원")
                                .font(.body2)
                                .foregroundStyle(.jgray30)
                        }
                        
                        Rectangle()
                            .fill(.jgray80)
                            .frame(height: scaledHeight(1))
                            .padding(.vertical, scaledHeight(20))
                        
                        HStack {
                            Text("총 결제 금액")
                                .font(.detail2)
                                .foregroundStyle(.jgray20)
                            
                            Spacer()
                            
                            Text("\(orderDetail.totalPrice)")
                                .font(.headline3)
                                .foregroundStyle(.jgray30)
                        }
                    }
                    .padding(.vertical, scaledHeight(15))
                    .padding(.horizontal, scaledWidth(20))
                }
                .background(.jgray95)
                .cornerRadius(scaledWidth(10))
            }
            .padding(.bottom, scaledHeight(40))
            
            Button {
                overlayManager.hideSheet()
            } label: {
                Text("확인")
                    .font(.label1)
                    .foregroundStyle(.jgray100)
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
    
    func formatDate(_ dateString: String) -> String {
        // 초 소수점 자릿수를 3자리로 줄임
        let trimmedDateString = trimMilliseconds(dateString)

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // 수정된 입력 포맷
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd" // 원하는 출력 포맷

        if let date = inputFormatter.date(from: trimmedDateString) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }

    func trimMilliseconds(_ dateString: String) -> String {
        if let range = dateString.range(of: "\\.\\d+", options: .regularExpression) {
            let milliseconds = dateString[range] // ".242411" 추출
            let trimmedMilliseconds = String(milliseconds.prefix(4)) // ".242"
            return dateString.replacingCharacters(in: range, with: trimmedMilliseconds)
        }
        return dateString // 변경하지 않고 반환
    }
}
