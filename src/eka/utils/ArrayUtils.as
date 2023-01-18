
/* -------------------------------------------------------------------------

	Name : ArrayUtils
	Package : eka.utils
	Version : 1.0.0
	Date :  2004-10-21
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net
	
	-------------------------------------------------------------------------
	DESCRIPTION
	-------------------------------------------------------------------------
		Permet de faire des transformations sur les tableaux
		
	STATIC METHODS
		
		clone(ar:Array):Array
			Duplique le tableau (Pas la m�me r�f�rence)
	
		insertAt (ar:Array, item, index:Number):Array
			Ajoute un �l�ment � l'index donn� et retourne le nouveau tableau
	
		remove(ar:Array, item):Boolean
			Supprime un �l�ment d'un tableau
			Renvoi true si un ou plusieurs �l�ments du tableaux sont supprim�s
		
		exists( ar:Array , o) : Boolean
			D�termine si un �l�ment appartient � un tableau
			Renvoi true si l'�l�ment est trouv�
		
		indexOf (ar:Array, item):Number
			Trouve l'index d'un item, renvoi -1 si l'item n'est pas trouv�

		shuffle(ar:Array):Array
			Renvoi un tableau correspond au m�lange les �l�ments d'un tableau 
			(m�thode des permutations al�atoires - cf : NeoLao)
		
	THANKS
		NeoLao : <a href="http://www.neo-lao.com/ressources/index.php?page=14&fiche=35">Arrayutils</a>
			
		
		
------------------------------------------------------------------------- */


class eka.utils.ArrayUtils {

	// ----o Author Properties

	public static var className:String = "ArrayUtils" ;
	public static var classPackage:String = "eka.utils";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Public Methods

	public static function clone (ar:Array) :Array {
		return ar.slice() ;
	}
	
	public static function insertAt ( ar:Array, o, i:Number ) :Array {
		if (i== undefined || i>=ar.length) return ar.concat(o) ;
		return (ar.slice(0, i).concat(o)).concat(ar.slice(i)) ;
	}
	
	public static function remove (ar:Array, o):Boolean {
		var l:Number = ar.length ;
		var b:Boolean = false ;
		while (--l > -1) {
			if (ar[l] == o) {
				ar.splice (l, 1) ;
				b = true ;
			}
		}
		return b ;
	}
	
	public static function indexOf( ar:Array, o ) :Number {
		var l:Number = ar.length;
		while ( --l > -1 ) if (ar[l] == o) return l ; 
		return -1 ;
	}
	
	public static function exists( ar:Array , o) :Boolean {
		return (indexOf(ar,o) != -1) ;
	}
	
	public static function shuffle ( ar:Array ) :Array {
		var res:Array = clone(ar);
		var tmp ;
		var rdm:Number ;
		var l:Number = res.length ;
		for (var i:Number = 0 ; i<l ; i++) {
			rdm = Math.floor ( Math.random () * l) ;
			tmp = res[rdm] ;
			res[rdm] = res[i] ;
			res[i] = tmp ;
		}
		return res ;
	}

}
