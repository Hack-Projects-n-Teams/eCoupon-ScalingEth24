// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IERC1155eCoupon.sol";
// import "./SafeMath.sol";

contract PaymentProcessor is Ownable {
    IERC20 public paymentToken_;
    IERC1155eCoupon public eCoupon_;

    struct Payment {
        uint256 vendorID;
        uint256 eCouponID;
        uint256 inititalAmount;
        uint256 paidAmount;
        uint256 discountValue;
        // uint256 referralValue;
        string invoiceCID;
    }
        
    mapping(uint256 => Payment) public payments_;
    uint256 public nextPaymentId_;
    
    struct Vendor {
        address vendorAddress;
        string name;
        string storeLink;
    }
    
    mapping(uint vendorID => Vendor) public vendors;
    mapping(uint vendorID => uint vendorBalance) public vendorBalances_;
    
    // TODO implement referrals
    // mapping(address => uint256) public referralBalances;

    event PaymentProcessed(uint indexed paymentID, uint indexed vendorID, uint indexed couponID, uint initialCheck, uint paidCheck, uint discountedValue);
    // event ReferralBonus(address indexed referral, uint256 amount);
    
    constructor(
        address _eCouponContract,
        address _erc20Token
    ) Ownable(msg.sender) {
        setCouponContract(_eCouponContract);
        setPaymentToken(_erc20Token);
    }
    // function to set eCoupon address
    function setCouponContract(address _eCouponContract) public onlyOwner {
        eCoupon_ = IERC1155eCoupon(_eCouponContract);
    }

    function setPaymentToken(address _erc20Token) public onlyOwner {
        paymentToken_ = IERC20(_erc20Token);
    }

    // functino to process payment. Inputs: sum, invoiceCID, vendorID, couponID
    function processPaymentWithCoupon(uint _amount, uint _vendorID, uint _couponID, string memory _invoiceCID) public returns(uint) {
        
        // check input values
        require(_couponID == 0, "Coupon ID must not be empty");
        require(_vendorID == 0, "Vendor ID must not be empty");
        require(bytes(_invoiceCID).length > 0, "Invoice CID must not be empty");
        
        // check that caller own coupon
        require(eCoupon_.balanceOf(msg.sender, _couponID) > 0, "Not a owner of the coupon");
        
        // get amount to pay
        uint discountValue = getDiscountValueWithCoupon(_amount, _couponID);
        uint amountToPay = _amount - discountValue;
        
        // Transfer payment tokens (erc20) from caller to contract
        paymentToken_.transferFrom(msg.sender, address(this), amountToPay);

        // Update vendor balance
        vendorBalances_[_vendorID] += amountToPay;
        
        // TODO
        // update referral balance
        // calculate referral balance
        // Update referral balance if referral provided

        // use coupon
        // Create an array to store the coupon IDs
        uint256[] memory couponIDs = new uint256[](1);
        couponIDs[0] = _couponID;

        // Create an array to store the coupon amount
        uint256[] memory values = new uint256[](1);
        values[0] = 1;

        eCoupon_.useCoupon(msg.sender, couponIDs, values, discountValue);

        // save payment data
        uint paymentID = nextPaymentId_++;
        payments_[paymentID] = Payment(_vendorID, _couponID, _amount, amountToPay, discountValue, _invoiceCID);

        // emit event
        emit PaymentProcessed(paymentID, _vendorID, _couponID, _amount, amountToPay, discountValue);
        return paymentID;
    }

    // function to calculate amount to pay with discount coupon
    function getAmountToPayWithCoupon(uint _amount, uint _couponID) public view returns(uint) {
        uint discountValue = getDiscountValueWithCoupon(_amount, _couponID);
        return _amount - discountValue;
    }

    // function to calculate total payment amount with discount
    function getDiscountValueWithCoupon(uint _amount, uint _couponID) public view returns(uint) {
        uint discountPercent = getCouponDiscountPercentage(_couponID);
        return (_amount * discountPercent) / 100;
    }

    // function to view discount percentage from the coupon
    function getCouponDiscountPercentage(uint _couponID) public view returns(uint) {
        return eCoupon_.getDiscountPercent(_couponID);
    }
}

// Second contract - Payment processor + Coupon Execution
// 1. Accept ERC20.
// 2. Accept coupon.
// 3. Verify coupon.
// 4. Change coupon status. 
    // Update coupon metadata.
    // set Used = true.
    // set invoiceURL - ipfs CID json with purchase
// 7. User use coupon to get discount.


// Referals
// 1. Stuct - address, id, name -mrbeast
// 2. Balance
// 3. % referal cut - vendor set default value. % from 
// 3.A unique 
// + parameter for DiscountCoupon
// 4. When customer input promoCode
// + User input referralPromoID when mintcoupon.
// + describe that we want to have additional verification for claiming promocoded coupon.
// + or mint only by link.
// + SET LIMIT on promo code amount. First 500 users will get discount.
// + Vendor create unique coupon collection for MrBeast.
// + 
// 5. Coupon price is 0 for MVP.

// contract PaymentProcessor {

//   function useCoupon(uint256 couponCollectionID, uint couponID) external {

//   }

//   function acceptPayment(address token, uint256 amount, bytes memory couponData) external{

//   }

//   function setInvoiceURL(uint256 couponCollectionID, uint couponID, string memory invoiceURL) external{

//   }

//   // function that will prepare coupon array & will call use coupon
//     function applyDiscountCoupon(uint couponCollectionID, address couponOwner, uint amount) internal {
//         // Create an array to store the coupon IDs
//         uint256[] memory couponIDs = new uint256[](1);
//         couponIDs[0] = couponCollectionID;

//         // Create an array to store the coupon amount
//         uint256[] memory values = new uint256[](1);
//         values[0] = amount;

//         DiscountCoupons.useCoupon(couponOwner, couponIDs, values);
//     }
// }