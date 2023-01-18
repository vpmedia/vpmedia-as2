class ascb.util.StringUtils {

  private static var _oCodeMap:Object;

  public static function toInitialCap(sOriginal:String):String {
    return sOriginal.charAt(0).toUpperCase() + sOriginal.substr(1).toLowerCase();
  }

  public static function toTitleCase(sOriginal:String):String {
    var aWords:Array = sOriginal.split(" ");
    for (var i:Number = 0; i < aWords.length; i++) {
      aWords[i] = toInitialCap(aWords[i]);
    }
    return (aWords.join(" "));
  }

  public static function trim(sOriginal:String):String {

    // Split the string into an array of characters.
    var aCharacters = sOriginal.split("");

    // Remove any whitespace elements from the beginning of the array using
    // splice(). Use a break statement to exit the loop when you reach a
    // non-whitespace character to prevent it from removing whitespace
    // in the middle of the string.
    for (var i:Number = 0; i < aCharacters.length; i++) {
      if (aCharacters[i] == "\r" ||
          aCharacters[i] == "\n" ||
          aCharacters[i] == "\f" ||
          aCharacters[i] == "\t" ||
          aCharacters[i] == " ") {
        aCharacters.splice(i, 1);
        i--;
      } else {
        break;
      }
    }

    // Loop backward through the removing whitespace elements until a
    // non-whitespace character is encountered. Then break out of the loop.
    for (var i:Number = aCharacters.length - 1; i >= 0; i--) {
      if (aCharacters[i] == "\r" ||
          aCharacters[i] == "\n" ||
          aCharacters[i] == "\f" ||
          aCharacters[i] == "\t" ||
          aCharacters[i] == " ") {
        aCharacters.splice(i, 1);
      } else {
        break;
      }
    }

    // Recreate the string with the join() method and return the result.
    return aCharacters.join("");
  }

  public static function encode(sOriginal:String):String {

    // The codeMap property is assigned to the String class when the encode() method
    // is first run. Therefore, if no codeMap is yet defined, it needs to be created.
    if (_oCodeMap == undefined) {

      // The codeMap property is an associative array that maps each original code
      // point to another code point.
      _oCodeMap = new Object();

      // Create an array of all the code points from 0 to 255.
      var aOriginalMap:Array = new Array();
      for (var i:Number = 0; i <= 255; i++) {
        aOriginalMap.push(i);
      }

      var nRandom:Number;

      // Create a temporary array that is a copy of the origMap array.
      var aTemporary:Array = aOriginalMap.concat();

      // Loop through all the character code points in origMap.
      for (var i:Number = 0; i < aOriginalMap.length; i++) {

        // Create a random number that is between 0 and the last index of charTemp.
        nRandom = Math.round(Math.random() * (aTemporary.length-1));

        // Assign to codeMap values such that the keys are the original code points,
        // and the values are the code points to which they should be mapped.
        _oCodeMap[aOriginalMap[i]] = aTemporary[nRandom];

        // Remove the elements from charTemp that was just assigned to codeMap. 
        // This prevents duplicates.
        aTemporary.splice(nRandom, 1);
      }
    }

    // Split the string into an array of characters.
    var aCharacters:Array = sOriginal.split("");

    // Replace each character in the array with the corresponding value from codeMap.
    for (var i:Number = 0; i < aCharacters.length; i++) {
      aCharacters[i] = String.fromCharCode(_oCodeMap[aCharacters[i].charCodeAt(0)]);
    }

    // Return the encoded string.
    return aCharacters.join("");
  }

  public static function decode(sEncoded:String):String {

    // Split the encoded string into an array of characters.
    var aCharacters = sEncoded.split("");

    // Create an associative array that reverses the keys and values of codeMap.
    // This allows you to do a reverse lookup based on the encoded character
    // rather than the original character.
    var oReverseMap:Object = new Object();
    for (var key in _oCodeMap) {
      oReverseMap[_oCodeMap[key]] = key;
    }

    // Loop through all the characters in the array, and replace them
    // with the corresponding value from reverseMap--thus recovering
    // the original character values.
    for (var i:Number = 0; i < aCharacters.length; i++) {
      aCharacters[i] = String.fromCharCode(oReverseMap[aCharacters[i].charCodeAt(0)]);
    }

    // Return the decoded string.
    return aCharacters.join("");
  }

}