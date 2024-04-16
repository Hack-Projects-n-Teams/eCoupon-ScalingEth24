"use client"

import React, { createContext, useContext } from "react"
import { useState } from "react"
//import { couponDemo } from "./CouponsDemo";

export const couponDemo = [
  [
  "Get 10% on Nike", //Coupon name
  "10", //Discount %
  "1024", // Max coupon amount
  "10/12/2024", //Coupon expire date
  "Amazon", // Vendor Name"
  "https://www.amazon.com/s?k=Nike"  //Vendor shop link
  ],

  [
      "Get 15% on Adidas", //Coupon name
      "15", //Discount %
      "1024", // Max coupon amount
      "10/12/2024", //Coupon expire date
      "Amazon", // Vendor Name"
      "https://www.amazon.com/s?k=Adidas"  //Vendor shop link
      ],

  [
      "Get 20% on New Balance", //Coupon name
      "20", //Discount %
      "1024", // Max coupon amount
      "10/12/2024", //Coupon expire date
      "Amazon", // Vendor Name"
      "https://www.amazon.com/s?k=NewBalance"  //Vendor shop link
      ],

      [
        "Get 10% on Sony", //Coupon name
        "10", //Discount %
        "1024", // Max coupon amount
        "10/12/2024", //Coupon expire date
        "Amazon", // Vendor Name"
        "https://www.amazon.com/s?k=Sony"  //Vendor shop link
        ],
      
      [
        "Get 15% on Samsung", //Coupon name
        "15", //Discount %
        "1024", // Max coupon amount
        "10/12/2024", //Coupon expire date
        "Amazon", // Vendor Name"
        "https://www.amazon.com/s?k=Samsung"  //Vendor shop link
      ],
  
      [
        "Get 30% on Apple", //Coupon name
        "30", //Discount %
        "1024", // Max coupon amount
        "10/12/2024", //Coupon expire date
        "Ebay", // Vendor Name"
        "https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2510209.m570.l1313&_nkw=apple&_sacat=0"  //Vendor shop link
      ],
      [
        "Get 15% on HTC", //Coupon name
        "15", //Discount %
        "1024", // Max coupon amount
        "10/12/2024", //Coupon expire date
        "Amazon", // Vendor Name"
        "https://www.amazon.com/s?k=htc"  //Vendor shop link
      ],
  
      [
        "Get 40% on Google Phone", //Coupon name
        "40", //Discount %
        "1024", // Max coupon amount
        "10/12/2024", //Coupon expire date
        "Google store", // Vendor Name"
        "https://store.google.com/category/phones?hl=de"  //Vendor shop link
      ]
      
]


interface CouponContextProps {
  couponsData: Array<Array<string>>;
  SetCouponsData?: (data:Array<Array<string>>) => void;
}

const defaultState  = {
  couponsData:couponDemo
}
const ConponContext = createContext<CouponContextProps>(defaultState);

export default function CouponsProvider({children}:{
    children: React.ReactNode
  }) 
{

  const [couponContext, setCouponContext] = useState<Array<Array<string>>>(couponDemo);


        return(
          <ConponContext.Provider
          value={{
            couponsData:couponContext,
            SetCouponsData:setCouponContext
          }}>
            {children} 

            </ConponContext.Provider>

          )
    
}

export const useCouponContext = () =>  useContext(ConponContext)