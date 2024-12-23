//
//  OnboardingFifthView.swift
//  JangbuRich
//
//  Created by 변상우 on 11/19/24.
//

import SwiftUI

struct OnboardingFifthView: View {
    
    @EnvironmentObject var authStore: AuthStore
    
    @Binding var isSuccessLogin: Bool
    
    @State private var prepayment: String = ""
    @State private var prepaymentPeriod: String = ""
    @State private var isAvailableReservation: Bool?
    @State private var isAvailableNumber: String = ""
    @State private var isCompleteOnboarding: Bool = false
    
    var nextButtonStatus: Bool {
        return !prepayment.isEmpty && !prepaymentPeriod.isEmpty && isAvailableReservation != nil && (isAvailableReservation == true && !isAvailableNumber.isEmpty)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text("매장 이용을 위한 추가 정보를 입력해주세요")
                        .font(.headline1)
                        .foregroundStyle(.jgray20)
                        .padding(.top, scaledHeight(61))
                    
                    VStack(spacing: scaledHeight(40)) {
                        VStack {
                            HStack(spacing: 0) {
                                Text("최소 선결제 금액")
                                    .font(.body2)
                                    .foregroundStyle(.jgray30)
                                
                                Text("*")
                                    .font(.body2)
                                    .foregroundStyle(.jOrange)
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 0) {
                                Text("- 선결제 여부는 필수예요\n- 최소 10만 원부터 설정 가능해요")
                                    .font(.detail1)
                                    .foregroundStyle(.jgray60)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.bottom, scaledHeight(10))
                            
                            HStack {
                                Spacer()
                                
                                JLeftTextField(unit: "원", placeholder: "100,000", text: $prepayment)
                                    .frame(width: scaledWidth(200))
                            }
                        }
                        
                        VStack {
                            HStack(spacing: 0) {
                                Text("선결제 금액 사용 기간")
                                    .font(.body2)
                                    .foregroundStyle(.jgray30)
                                
                                Text("*")
                                    .font(.body2)
                                    .foregroundStyle(.jOrange)
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 0) {
                                Text("- 최소 1달부터 설정 가능해요")
                                    .font(.detail1)
                                    .foregroundStyle(.jgray60)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.bottom, scaledHeight(10))
                            
                            HStack {
                                Spacer()
                                
                                JLeftTextField(unit: "일", placeholder: "31", text: $prepaymentPeriod)
                                    .frame(width: scaledWidth(200))
                            }
                        }
                        
                        VStack {
                            HStack(spacing: 0) {
                                Text("예약 가능 여부")
                                    .font(.body2)
                                    .foregroundStyle(.jgray30)
                                
                                Text("*")
                                    .font(.body2)
                                    .foregroundStyle(.jOrange)
                                
                                Spacer()
                            }
                            
                            Rectangle()
                                .fill(.jgray90)
                                .frame(height: scaledHeight(1))
                                .padding(.vertical, scaledHeight(20))
                            
                            Button {
                                isAvailableReservation = false
                            } label: {
                                HStack(spacing: scaledHeight(10)) {
                                    Image(isAvailableReservation ?? true ? .checkAllButton : .checkAllButtonFill)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: scaledHeight(24))
                                    
                                    Text("불가능")
                                        .font(.label1)
                                        .foregroundStyle(.jgray30)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, scaledHeight(20))
                            }
                            
                            Button {
                                isAvailableReservation = true
                            } label: {
                                HStack(spacing: scaledHeight(10)) {
                                    Image(isAvailableReservation ?? false ? .checkAllButtonFill : .checkAllButton)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: scaledHeight(24))
                                    
                                    Text("가능")
                                        .font(.label1)
                                        .foregroundStyle(.jgray30)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, scaledHeight(10))
                            }
                            
                            HStack(spacing: 0) {
                                Text("최대 예약 가능 인원수")
                                    .font(.body2)
                                    .foregroundStyle(isAvailableReservation ?? false ? .jgray20 : .jgray40)
                                
                                Text("*")
                                    .font(.body2)
                                    .foregroundStyle(.jOrange)
                                
                                Spacer()
                                
                                JLeftTextField(unit: "명", placeholder: "0", isEditable: isAvailableReservation ?? true, text: $isAvailableNumber)
                                    .frame(width: scaledWidth(200))
                            }
                            
                        }
                    }
                    .padding(.top, scaledHeight(110))
                    .padding(.horizontal, scaledWidth(170))
                    
                    Spacer()
                    
                    Button {
                        print("회원가입 버튼 클릭")
                        authStore.onboardingUser.minPrepayment = Int(prepayment) ?? 0
                        authStore.onboardingUser.prepaymentDuration = Int(prepaymentPeriod) ?? 0
                        
                        if let isAvailableReservation = isAvailableReservation {
                            authStore.onboardingUser.reservationAvailable = isAvailableReservation
                            
                            if isAvailableReservation {
                                authStore.onboardingUser.maxReservation = Int(isAvailableNumber) ?? 0
                            } else {
                                authStore.onboardingUser.maxReservation = 0
                            }
                        }
                        
                        print("authStore.onboardingUser: \(authStore.onboardingUser)")
                        
                        if let storeImage = authStore.onboardingStoreImage,
                           let menuImages = authStore.onboardingMenuImage {
                            authStore.createUser(user: authStore.onboardingUser, storeImage: storeImage, menuImages: menuImages) { result in
                                if result {
                                    print("회원가입 성공!!")
                                    authStore.isFinishedOnboarding = true
                                    isSuccessLogin = false
                                } else {
                                    print("회원가입 서버 연동 실패...")
                                }
                            }
                        } else {
                            print("데이터가 누락, 회원가입 실패.")
                        }
                    } label: {
                        Text("완료")
                            .font(.label1)
                            .foregroundStyle(nextButtonStatus ? .jgray100 : .jgray20)
                            .frame(maxWidth: .infinity)
                            .frame(height: scaledHeight(48))
                            .cornerRadius(scaledHeight(10))
                            .background(
                                RoundedRectangle(cornerRadius: scaledHeight(10))
                                    .fill(nextButtonStatus ? .jgray20 : .jgray80)
                            )
                    }
                    .padding(.horizontal, scaledWidth(210))
                    .padding(.bottom, scaledHeight(40))
                }
                .frame(minHeight: geometry.size.height)
            }
            .scrollDisabled(true)
        }
        .customNavigationBar(title: "") {
            isSuccessLogin = false
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}
