class ascb.util.DateUtils {

  public static var MILLISECOND:Number = 1;
  public static var SECOND:Number = MILLISECOND * 1000;
  public static var MINUTE:Number = SECOND * 60;
  public static var HOUR:Number = MINUTE * 60;
  public static var DAY:Number = HOUR * 24;
  public static var WEEK:Number = DAY * 7;

  public static function addTo(dOriginal:Date, nYears:Number, nMonths:Number, nDays:Number, nHours:Number, nMinutes:Number, nSeconds:Number, nMilliseconds:Number):Date {
    if(nYears == undefined) {
      nYears = 0;
    }
    if(nMonths == undefined) {
      nMonths = 0;
    }
    if(nDays == undefined) {
      nDays = 0;
    }
    if(nHours == undefined) {
      nHours = 0;
    }
    if(nMinutes == undefined) {
      nMinutes = 0;
    }
    if(nSeconds == undefined) {
      nSeconds = 0;
    }
    if(nMilliseconds == undefined) {
      nMilliseconds = 0;
    }
    var dNew:Date = new Date(dOriginal.getTime());
    dNew.setFullYear(dNew.getFullYear() + nYears);
    dNew.setMonth(dNew.getMonth() + nMonths);
    dNew.setDate(dNew.getDate() + nDays);
    dNew.setHours(dNew.getHours() + nHours);
    dNew.setMinutes(dNew.getMinutes() + nMinutes);
    dNew.setSeconds(dNew.getSeconds() + nSeconds);
    dNew.setMilliseconds(dNew.getMilliseconds() + nMilliseconds);
    return dNew;
  }

  private static function elapsedDate(dOne:Date, dTwo:Date):Date {
    if(dTwo == undefined) {
      dTwo = new Date();
    }
    return new Date(dOne.getTime() - dTwo.getTime());
  }

  public static function elapsedMilliseconds(dOne:Date, dTwo:Date, bDisregard:Boolean):Number {
    if(bDisregard) {
      return elapsedDate(dOne, dTwo).getUTCMilliseconds();
    }
    else {
      return (dOne.getTime() - dTwo.getTime());
    }
  }

  public static function elapsedSeconds(dOne:Date, dTwo:Date, bDisregard:Boolean):Number {
    if(bDisregard) {
      return (elapsedDate(dOne, dTwo).getUTCSeconds());
    }
    else {
      return Math.floor(elapsedMilliseconds(dOne, dTwo) / SECOND);
    }
  }

  public static function elapsedMinutes(dOne:Date, dTwo:Date, bDisregard:Boolean):Number {
    if(bDisregard) {
      return (elapsedDate(dOne, dTwo).getUTCMinutes());
    }
    else {
      return Math.floor(elapsedMilliseconds(dOne, dTwo) / MINUTE);
    }
  }

  public static function elapsedHours(dOne:Date, dTwo:Date, bDisregard:Boolean):Number {
    if(bDisregard) {
      return (elapsedDate(dOne, dTwo).getUTCHours());
    }
    else {
      return Math.floor(elapsedMilliseconds(dOne, dTwo) / HOUR);
    }
  }

  public static function elapsedDays(dOne:Date, dTwo:Date, bDisregard:Boolean):Number {
    if(bDisregard) {
      return (elapsedDate(dOne, dTwo).getUTCDate() - 1);
    }
    else {
      return Math.floor(elapsedMilliseconds(dOne, dTwo) / DAY);
    }
  }

  public static function elapsedMonths(dOne:Date, dTwo:Date, bDisregard:Boolean):Number {
    if(bDisregard) {
      return (elapsedDate(dOne, dTwo).getUTCMonth());
    }
    else {
      return (elapsedDate(dOne, dTwo).getUTCMonth() + elapsedYears(dOne, dTwo) * 12);
    }
  }

  public static function elapsedYears(dOne:Date, dTwo:Date):Number {
    return (elapsedDate(dOne, dTwo).getUTCFullYear() - 1970);
  }

  public static function elapsed(dOne:Date, dTwo:Date):Object {
    var oElapsed:Object = new Object();
    oElapsed.years = elapsedYears(dOne, dTwo);
    oElapsed.months = elapsedMonths(dOne, dTwo, true);
    oElapsed.days = elapsedDays(dOne, dTwo, true);
    oElapsed.hours = elapsedHours(dOne, dTwo, true);
    oElapsed.minutes = elapsedMinutes(dOne, dTwo, true);
    oElapsed.seconds = elapsedSeconds(dOne, dTwo, true);
    oElapsed.milliseconds = elapsedMilliseconds(dOne, dTwo, true);
    return oElapsed;
  }



}