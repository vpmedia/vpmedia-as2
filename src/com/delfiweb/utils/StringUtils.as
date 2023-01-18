
/**
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * 
 * The Initial Developer of the Original Code is
 * DELOISON Matthieu -- www.delfiweb.com.
 * Portions created by the Initial Developer are Copyright (C) 2006-2007
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s) :
 * 
 */




/**
 * Add some functions for string.
 * 
 * 
 * Permet de faire des traitements sur une chaine de caractères.
 * 
 * 
 * 
 * @author  Matthieu
 * @version 1.0
 * @usage   
 * @since  30/11/2006 
 */
class com.delfiweb.utils.StringUtils
{	
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 * @return  
	 */
	private function StringUtils (){}
	
	
	
	/**
	 * Search and replace some id in a string.
	 * 
	 * 
	 * @param   sTxt	: string to be replace    
	 * @param   sSearch : id to find
	 * @param   sBy     : new value of id
	 * @return  the new string updated
	 */
	public static function strReplace(sTxt:String, sSearch:String, sBy:String):String
	{
		var pos:Number;
		
		// Recherche la chaîne et renvoie la position de la première occurrence 
		if ( sTxt.indexOf(sSearch) != -1)
		{
			pos = sTxt.indexOf (sSearch); // Renvoie les caractères dans une chaîne à partir de l'index spécifié
			sTxt = sTxt.substr (0, pos) + sBy + sTxt.substr (pos + sSearch.length);
		}

		return sTxt;
	}
	
	
		
	/**
	 * Search and replace some id in a string.
	 * An array of id by an other array of values.
	 * 
	 * @param   sTxt  	: string to be replace         
	 * @param   aSearch : array of id
	 * @param   aBy     : array of new values
	 * @return  
	 */
	public static function arrayReplace (sTxt:String, aSearch:Array, aBy:Array):String
	{
		var aTemp:Array = new Array();		
		
		for ( var i in aSearch)
		{
			/* split _ Divise un objet String en sous-chaînes en le séparant aux endroits 
			 où le paramètre delimiter spécifié apparaît 
			 et renvoie les sous-chaînes dans un tableau */
			
			// pop _ Supprime le dernier élément d'un tableau et renvoie la valeur de cet élément.

			
			/* join _ Convertit les éléments d'un tableau en chaînes, 
			 insère le séparateur spécifié entre les éléments, les concatène,
			 puis renvoie la chaîne obtenue. */
			
			aTemp = new Array();
			aTemp = sTxt.split( aSearch[i] );
			
			sTxt = aTemp.join( aBy[i] );
		}
		
		return sTxt;
	}
	
	


	/*----------------------------------------------------------*/
	/*-------------- Other -------------------------------------*/
	/*----------------------------------------------------------*/
	
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return the string representation of this instance
	 */
	public static function toString():String
	{
		return "[object StringUtils]";
	}
	
	
}// end of class


