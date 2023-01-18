
/* ---------- 	StringUtils 1.0.0

	Name : 	StringUtils
	Package : eka.utils
	Version : 2.0.0
	Date :  2005-05-26
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	Date de création :  2004-11-09


	THANKS : 
		Federico:: federico@infogravity.net (lTrim / rTrim / trim)
		
		
	StringUtils.replace
		Cherche une suite de caractères dans une chaine pour la remplacer par une autre
		Paramètres :
			str : Chaine de caractêres à traiter
			search : Chaine de caractère à chercher
			replace : Chaine de caractère de remplacement
	
	StringUtils.lTrim
		Supprime tous les caractères d'espacement au début de la chaine de caractères. 
		Une chaine dont chaque caractère est un caractère d'espacement lui est transmise.
	
	StringUtils.rTrim
		Supprime tous les caractères d'espacement à la fin de la chaine de caractères. 
		Une chaine dont dont chaque caractère est un caractère d'espacement lui est transmise.
	
	StringUtils.trim
		Supprime tous les caractères d'espacement au début et à la fin de la chaine de caractères.
		Une chaine dont dont chaque caractère est un caractère d'espacement lui est transmise.
	
	StringUtils.stringToArray
		Convertit une chaine de caractères en tableau contenant un caractère par index.
		
	StringUtils.arrayToString
		Transforme un tableau en chaine de caractère constituée de la concatenation de ses éléments.	
		
	StringUtils.reverse
		Inverse l'ordre des caractères d'une chaine.
	
	StringUtils.stripTag(s)
		Permet de supprimer tous les Tags (balises) contenus dans une chaine de caractère.
	
----------  */	

class eka.utils.StringUtils {
   
	//  ------o Author Properties
		
	public static var className : String = "StringUtils" ;
	public static var classPackage : String = "eka.utils";
	public static var version : String = "1.0.1";
	public static var author : String = "eKameleon";
	public static var link : String = "http://www.ekameleon.net" ;

	// -----o Enums
   
	static public var TAB:Number = 9 ;
	static public var LINEFEED:Number = 10 ;
	static public var CARRIAGE:Number = 13 ; 
	static public var SPACE:Number = 32 ; 
   
	// -----o Static Methods
	
	static public function arrayToString(p_ar:Array):String {
		return "" + p_ar.join("");
	}
	
	static public function lTrim(p_str:String):String {
		var s:String = p_str.toString();
		var l:Number = s.length ;
		var i:Number = 0 ;
		var c:Number = s.charCodeAt(i) ;
		while ( c==SPACE || c==CARRIAGE || c==LINEFEED || c== TAB) {
			c = s.charCodeAt(++i) ;
		}
		return s.substring(i, l) ;
	}

	static public function replace(str:String, search:String, replace:String):String {
		return str.split(search).join(replace);
	}
	
	static public function reverse(str:String):String {
      	var ar:Array = str.split("");
		ar.reverse() ;
		return ar.join("");
	}

	static public function stripTag(s:String):String {
		var i:Number = s.indexOf("<") ;
		if (i > -1) {
			s = stripTag( s.substring(0, i) + s.substring(s.indexOf(">", i) + 1 ) )  ;
		}
		return s ;
	}
	
	static public function stringToArray(p_str:String):Array {
		return p_str.split("");
	}

	static public function rTrim(p_str:String):String {
		var s:String = p_str.toString();
		var l:Number = s.length ;
		var i:Number = l - 1 ;
		var c:Number = s.charCodeAt(i) ;
		while(c==SPACE || c==CARRIAGE || c==LINEFEED || c== TAB) {
			c = s.charCodeAt(--i) ;
		}
		return s.substring(0, i+1) ;
	}

	static public function trim(p_str:String):String {
		var s:String = p_str.toString() ;
		return lTrim(rTrim(s)) ;
	}
      
	static public function upperCaseFirst(s:String):String {
		return s.substring(0,1).toUpperCase() + s.substring(1, s.length);
	}

}
