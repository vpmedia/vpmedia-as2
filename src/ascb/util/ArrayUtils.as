import ascb.util.NumberUtils;

class ascb.util.ArrayUtils {

  public static function randomize(aArray:Array):Array {
    var aCopy:Array = aArray.concat();
    var aRandomized:Array = new Array();
    var oElement:Object;
    var nRandom:Number;
    for(var i:Number = 0; i < aCopy.length; i++) {
      nRandom = NumberUtils.random(0, aCopy.length - 1);
      aRandomized.push(aCopy[nRandom]);
      aCopy.splice(nRandom, 1);
      i--;
    }
    delete aCopy;
    return aRandomized;
  }

  public static function average(aArray:Array):Number {
    return sum(aArray) / aArray.length;
  }

  public static function sum(aArray:Array):Number {
    var nSum:Number = 0;
    for(var i:Number = 0; i < aArray.length; i++) {
      if(typeof aArray[i] == "number") {
        nSum += aArray[i];
      }
    }
    return nSum;
  }

  public static function max(aArray:Array):Number {
    var aCopy:Array = aArray.concat();
    aCopy.sort(Array.NUMERIC);
    var nMaximum:Number = Number(aCopy.pop());
    delete aCopy;
    return nMaximum;
  }

  public static function min(aArray:Array):Number {
    var aCopy:Array = aArray.concat();
    aCopy.sort(Array.NUMERIC);
    var nMinimum:Number = Number(aCopy.shift());
    delete aCopy;
    return nMinimum;
  }

  public static function switchElements(aArray:Array, nIndexA:Number, nIndexB:Number):Void {
    var oElementA:Object = aArray[nIndexA];
    var oElementB:Object = aArray[nIndexB];
    aArray.splice(nIndexA, 1, oElementB);
    aArray.splice(nIndexB, 1, oElementA);
  }

  private static function objectEquals(oInstanceA:Object, oInstanceB:Object):Boolean {
    for(var sItem:String in oInstanceA) {
      if(oInstanceA[sItem] instanceof Object) {
        if(!objectEquals(oInstanceA[sItem], oInstanceB[sItem])) {
          return false;
        }
      }
      else {
        if(oInstanceA[sItem] != oInstanceB[sItem]) {
          return false;
        }
      }
    }
    return true;
  }

  public static function equals(aArrayA:Array, aArrayB:Array, bNotOrdered:Boolean, bRecursive:Boolean):Boolean {
    if(aArrayA.length != aArrayB.length) {
      return false;
    }
    var aArrayACopy:Array = aArrayA.concat();
    var aArrayBCopy:Array = aArrayB.concat();
    if(bNotOrdered) {
      aArrayACopy.sort();
      aArrayBCopy.sort();
    }
    for(var i:Number = 0; i < aArrayACopy.length; i++) {
      if(aArrayACopy[i] instanceof Array && bRecursive) {
        if(!equals(aArrayACopy[i], aArrayBCopy[i], bNotOrdered, bRecursive)) {
          delete aArrayACopy;
          delete aArrayBCopy;
          return false;
        }
      }
      else if(aArrayACopy[i] instanceof Object && bRecursive) {
        if(!objectEquals(aArrayACopy[i], aArrayBCopy[i], bNotOrdered, bRecursive)) {
          delete aArrayACopy;
          delete aArrayBCopy;
          return false;
        }
      }
      else if(aArrayACopy[i] != aArrayBCopy[i]) {
        delete aArrayACopy;
        delete aArrayBCopy;
        return false;
      }
    }
    delete aArrayACopy;
    delete aArrayBCopy;
    return true;
  }

  public static function findMatchIndex(aArray:Array, oElement:Object):Number {
    var nStartingIndex:Number = 0;
    var bPartialMatch:Boolean = false;
    if(typeof arguments[2] == "number") {
      nStartingIndex = arguments[2];
    }    
    else if(typeof arguments[3] == "number") {
      nStartingIndex = arguments[3];
    }
    if(typeof arguments[2] == "boolean") {
      bPartialMatch = arguments[2];
    }
    var bMatch:Boolean = false;
    for(var i:Number = nStartingIndex; i < aArray.length; i++) {
      if(bPartialMatch) {
        bMatch = (aArray[i].indexOf(oElement) != -1);
      }
      else {
        bMatch = (aArray[i] == oElement);
      }
      if(bMatch) {
        return i;
      }
    }
    return -1;
  }

  public static function findLastMatchIndex(aArray:Array, oElement:Object):Number {
    var nStartingIndex:Number = aArray.length;
    var bPartialMatch:Boolean = false;
    if(typeof arguments[2] == "number") {
      nStartingIndex = arguments[2];
    }    
    else if(typeof arguments[3] == "number") {
      nStartingIndex = arguments[3];
    }
    if(typeof arguments[2] == "boolean") {
      bPartialMatch = arguments[2];
    }
    var bMatch:Boolean = false;
    for(var i:Number = nStartingIndex; i >= 0; i--) {
      if(bPartialMatch) {
        bMatch = (aArray[i].indexOf(oElement) != -1);
      }
      else {
        bMatch = (aArray[i] == oElement);
      }
      if(bMatch) {
        return i;
      }
    }
    return -1;
  }

  public static function findMatchIndices(aArray:Array, oElement:Object, bPartialMatch:Boolean):Array {
    var aIndices:Array = new Array();
    var nIndex:Number = findMatchIndex(aArray, oElement, bPartialMatch);
    while(nIndex != -1) {
      aIndices.push(nIndex);
      nIndex = findMatchIndex(aArray, oElement, bPartialMatch, nIndex + 1);
    }
    return aIndices;
  }

/*  public static function duplicate(aArray:Array, bRecursive:Boolean):Array {
    if(bRecursive) {
      var aDuplicate:Array = new Array();
      for(var i:Number = 0; i < aArray.length; i++) {
        if(aArray[i] instanceof Array) {
trace("array: " + aArray[i]);
          aDuplicate[i] = duplicate(aArray[i], bRecursive);
        }
        else {
trace("non-array: " + aArray[i]);
          aDuplicate[i] = aArray[i];
        }
      }
      return aDuplicate;
    }
    else {
      return aArray.concat();
    }
  }
*/

  public static function duplicate(oArray:Object, bRecursive:Boolean) {
    var oDuplicate:Object;
    if(bRecursive) {
      if(oArray instanceof Array) {
        oDuplicate = new Array();
        for(var i:Number = 0; i < oArray.length; i++) {
          if(oArray[i] instanceof Object) {
            oDuplicate[i] = duplicate(oArray[i]);
          }
          else {
            oDuplicate[i] = oArray[i];
          }
        }
        return oDuplicate;
      }
      else {
        var oDuplicate:Object = new Object();
        for(var sItem:String in oArray) {
          if(oArray[sItem] instanceof Object && !(oArray[sItem] instanceof String) && !(oArray[sItem] instanceof Boolean) && !(oArray[sItem] instanceof Number)) {
            oDuplicate[sItem] = duplicate(oArray[sItem], bRecursive);
          }
          else {
            oDuplicate[sItem] = oArray[sItem];
          }
        }
        return oDuplicate;
      }
    }
    else {
      if(oArray instanceof Array) {
        return oArray.concat();
      }
      else {
        var oDuplicate:Object = new Object();
        for(var sItem:String in oArray) {
          oDuplicate[sItem] = oArray[sItem];
        }
        return oDuplicate;
      }
    }
  }

  static public function toString(oArray:Object):String {
    var nLevel:Number = (arguments[1] == undefined) ? 0 : arguments[1];
    var sIndent:String = "";
    for(var i:Number = 0; i < nLevel; i++) {
      sIndent += "\t";
    }
    var sOutput:String = "";
    for(var sItem:String in oArray) {
      if(oArray[sItem] instanceof Object) {
        sOutput = sIndent + "** " + sItem + " **" + newline + toString(oArray[sItem], nLevel + 1) + sOutput;
      }
      else {
        sOutput += sIndent + sItem + ":" + oArray[sItem] + newline;
      }
    }
    return sOutput;
  }

}