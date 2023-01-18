class ascb.util.Calculator {

  public static function fv(nInterest:Number, nPaymentPeriods:Number, nPresentValue:Number):Number {
    // PV       = initial deposit (present value)  
    // interest = periodic interest rate
    // n        = number of periods

    var bContinuous:Boolean = (typeof arguments[3] == "boolean") ? arguments[3] : false;
    var nPeriodicPayment:Number = (typeof arguments[3] == "number") ? arguments[3] : undefined; 
 
    if(nPeriodicPayment == undefined) {
      var nMultiplier:Number = (bContinuous) ? Math.pow (Math.E, nPaymentPeriods * nInterest) : Math.pow ((1 + nInterest), nPaymentPeriods);
      return (nPresentValue * nMultiplier);
    }
    else {
      var nMultiplier:Number = Math.pow ((1 + nInterest), nPaymentPeriods);
      // Add FV of principle and FV of payments together to get total value
      return (nPresentValue * nMultiplier + nPeriodicPayment * ((nMultiplier-1) / nInterest));
    }
  }

  public static function pv(nInterest:Number, nPaymentPeriods:Number, nPeriodicPayment:Number):Number {
    // i   = periodic interest rate
    // n   = number of payment periods
    // PMT = periodic payment
  
    // Present Value compounded over n periods 
    // PV = PMT * ( (multiplier-1)/(i*multiplier))
    // where multiplier = Math.pow ((1 + i), n)
  
    var nMultiplier:Number = Math.pow((1 + nInterest), nPaymentPeriods);
    return (nPeriodicPayment * (nMultiplier-1) / (nInterest * nMultiplier)); 
  }

  public static function pmt(nInterest:Number, nPaymentPeriods:Number, nPresentValue:Number):Number { 
    // PV  = initial savings deposit or loan amount(present value)  
    // i   = periodic interest rate
    // n   = number of payment periods
    // PMT = periodic payment
  
    // Calculate the periodic payment needed to amortize (pay back) a loan
    var nMultiplier:Number = Math.pow((1 + nInterest), nPaymentPeriods);
  
    return (nPresentValue * nInterest * nMultiplier / (nMultiplier - 1));
  }



}