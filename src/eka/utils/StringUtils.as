
/* ---------- 	StringUtils 1.0.0

	Name : 	StringUtils
	Package : eka.utils
	Version : 2.0.0
	Date :  2005-05-26
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	Date de cr�ation :  2004-11-09


	THANKS : 
		Federico:: federico@infogravity.net (lTrim / rTrim / trim)
		
		
	StringUtils.replace
		Cherche une suite de caract�res dans une chaine pour la remplacer par une autre
		Param�tres :
			str : Chaine de caract�res � traiter
			search : Chaine de caract�re � chercher
			replace : Chaine de caract�re de remplacement
	
	StringUtils.lTrim
		Supprime tous les caract�res d'espacement au d�but de la chaine de caract�res. 
		Une chaine dont chaque caract�re est un caract�re d'espacement lui est transmise.
	
	StringUtils.rTrim
		Supprime tous les caract�res d'espacement � la fin de la chaine de caract�res. 
		Une chaine dont dont chaque caract�re est un caract�re d'espacement lui est transmise.
	
	StringUtils.trim
		Supprime tous les caract�res d'espacement au d�but et � la fin de la chaine de caract�res.
		Une chaine dont dont chaque caract�re est un caract�re d'espacement lui est transmise.
	
	StringUtils.stringToArray
		Convertit une chaine de caract�res en tableau contenant un caract�re par index.
		
	StringUtils.arrayToString
		Transforme un tableau en chaine de caract�re constitu�e de la concatenation de ses �l�ments.	
		
	StringUtils.reverse
		Inverse l'ordre des caract�res d'une chaine.
	
	StringUtils.stripTag(s)
		Permet de supprimer tous les Tags (balises) contenus dans une chaine de caract�re.
	
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
