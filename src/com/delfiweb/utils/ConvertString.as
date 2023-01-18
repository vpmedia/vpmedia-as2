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
 * Convert a string with separators in an array.
 * 
 * @usage :

var sExternalLink:String = "biblio.delfiweb.swf|delfiweb.swf";

var oConvertS:ConvertString = new ConvertString("|"); // la caractère de séparation de la chaine
var aInfos:Array = oConvertS.convert(sExternalLink);

aInfos[0] (value : biblio.delfiweb.swf)
aInfos[1] (value : delfiweb.swf)


 * 
 * @author  Matthieu DELOISON
 * @version 1.0
 * @since   
 */
class com.delfiweb.utils.ConvertString
{
	
	private var _sSeparator1:String; // the first separator
	private var _sSeparator2:String; // the second separator
	
	
	
	/* ****************************************************************************
	* CONSTRUCTOR
	**************************************************************************** */
	
	
	/**
	 * 
	 * 
	 * @usage   
	 * @param   s1 : the first separator
	 * @param   s2 : the second separator
	 * @return  
	 */
	public function ConvertString (s1:String,s2:String)
	{
		_sSeparator1 = s1;
		_sSeparator2 = s2;
	}
	

	/* *****************************************************************************
	* PUBLIC FUNCTIONS
	*******************************************************************************/
		
	
	/**
	 * String to convert in array
	 * 
	 * @usage   
	 * @param   string 
	 * @return  an array
	 */
	public function convert(string:String):Array
	{
		var aCree:Array = new Array(); // le tableau triée
		
		// si chaine vide on renvoit un tableau vide
		if(string==undefined || string=="") return aCree;
		
		var aIdContenu:Array = new Array();
		// tableau à 1 dimension si 1 seul séparateur
		aIdContenu = string.split(_sSeparator1);

		// si 2ème séparateur -> création d'un tableau à 2 dimensions
		if(_sSeparator2)
		{
			var temp:Array = new Array();
			for(var i in aIdContenu)
			{
				temp = new Array();
				temp = aIdContenu[i].split(_sSeparator2);
				var indexT = temp[0]; // récupération de l'index du tab
				var contenuT = temp[1]; // récupération du contenu du tab

				aCree[indexT] = contenuT;
			}
		}
		else aCree = aIdContenu;

		return aCree;		
	}
	
	
	
	/*------------------------------------------------------*/
	/*------------- Getter/Setter --------------------------*/
	/*------------------------------------------------------*/
	

	/**
	 * Permet de changer dynamiquement le séparateur s1
	 * 
	 * @param  s : le nouveau séparateur
	 */
	public function set separator1 (s:String)
	{
		_sSeparator1 = s;
	}
	
	
	/**
	 * Permet de changer dynamiquement le séparateur s2
	 * 
	 * @param  s : le nouveau séparateur
	 */
	public function set separator2 (s:String)
	{
		_sSeparator2 = s;
	}
	
	
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return the string representation of this instance
	 */
	public function toString ()
	{
		return "[object ConvertString]";
	}
}

