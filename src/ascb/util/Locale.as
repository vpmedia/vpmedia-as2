/**
Generally Locale is used by other classes such as the NumberFormat class.
*/

class ascb.util.Locale {

  public static function get ENGLISH():String {
    return "en";
  }
  public static function get SPANISH():String {
    return "es";
  }
  public static function get FRENCH():String {
    return "fr";
  }
  public static function get GERMAN():String {
    return "de";
  }
  public static function get JAPANESE():String {
    return "jp";
  }
  public static function get CHINESE():String {
    return "zh";
  }
  
  public static function get US():String {
    return "US";
  }
  public static function get UK():String {
    return "uk";
  }

  // Create private properties to store the language and variant for the
  // locale.
  private var _sLanguage:String;
  private var _sVariant:String;

  // Create private static properties to store the global language and
  // variant settings.
  private static var __sLanguage:String;
  private static var __sVariant:String;

  // Create getter and setter methods for the global static language and
  // variant settings.
  public static function get slanguage():String {
    return __sLanguage;
  }

  public static function set slanguage(sLanguage:String):Void {
    __sLanguage = sLanguage;
  }

  public static function get svariant():String {
    return __sVariant;
  }

  public static function set svariant(sVariant:String):Void {
    __sVariant = sVariant;
  }

  // Create getter and setter methods for the language and variant
  // settings.
  public function get language():String {

    // If the language is undefined, check to see if the global language
    // is defined. If so, use that. Otherwise, retreive the language from
    // the System.capabilities.language property.
    if(_sLanguage == undefined) {
      if(Locale.slanguage == undefined) {
        _sLanguage = System.capabilities.language.substr(0, 2);
      }
      else {
        _sLanguage = Locale.slanguage;
      }
    }
    return _sLanguage;
  }

  public function set language(sLanguage:String):Void {
    _sLanguage = sLanguage;
  }

  public function get variant():String {

    // As with the language setting, check to see if the variant is
    // undefined. If so, first try to use the global setting. Otherwise,
    // retrieve the value from the System.capapbilities.language property.
    // For some languages, attempt to localize based on timezone offset.
    if(_sVariant == undefined) {
      if(Locale.svariant == undefined) {
        if(System.capabilities.language.length > 2) {
          _sVariant = System.capabilities.language.substr(3);
        }
        else if(language == "en") {
          if(new Date().getTimezoneOffset() > 120) {
            _sVariant = "US";
          }
          else {
            _sVariant = "UK";
          }
        }
        else if(language == "es") {
          if(new Date().getTimezoneOffset() > 120) {
            _sVariant = "MX";
          }
          else {
            _sVariant = "ES";
          }
        }
      }
      else {
        _sVariant = Locale.svariant;
      }
    }
    return _sVariant;
  }

  public function set variant(sVariant:String):Void {
    _sVariant = sVariant;
  }

  // Create getter and setter methods for a single languageVariant string.
  // The string is comprised of the language and variant strings.
  public function get languageVariant():String {
    var sLanguageVariant:String = language;
    if(variant != undefined) {
      sLanguageVariant += "-" + variant;
    }
    return sLanguageVariant;
  }

  public function set languageVariant(sLanguageVariant:String):Void {
    var aParts:Array = sLanguageVariant.split("-");
    _sLanguage = aParts[0];
    _sVariant = aParts[1];
  }

  // Create a global, static languageVariant string.
  public static function get slanguageVariant():String {
    var sLanguageVariant:String = slanguage;
    if(svariant != undefined) {
      sLanguageVariant += "-" + svariant;
    }
    return sLanguageVariant;
  }

  public static function set slanguageVariant(sLanguageVariant:String):Void {
    var aParts:Array = sLanguageVariant.split("-");
    __sLanguage = aParts[0];
    __sVariant = aParts[1];
  }

  function Locale(sLanguage:String, sVariant:String) {
    _sLanguage = sLanguage;
    _sVariant = sVariant;
  }

  // Define reset and global, static reset methods.
  public function reset():Void {
    _sLanguage = undefined;
    _sVariant = undefined;
  }

  public static function sreset():Void {
    __sLanguage = undefined;
    __sVariant = undefined;
  }

}