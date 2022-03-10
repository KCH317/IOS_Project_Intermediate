//
//  CreditCard.swift
//  CreditCardList
//
//  Created by 권찬호 on 2022/03/10.
//

import Foundation

struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageUrl: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool?
}


struct PromotionDetail: Codable {
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
