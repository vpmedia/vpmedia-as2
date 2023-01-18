/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/**
 * It is a simple checksum formula used to validate a variety of account numbers, such as credit card numbers, etc.
 * <p>The Luhn algorithm or Luhn formula, also known as the "modulus 10" or "mod 10" algorithm, was developed in the 1960s as a method of validating identification numbers.</p>
 * <p><b>example</b><br>
 * {@code
 * import vegas.string.Luhn ;
 * 
 * var code:String = "456565654" ;
 * trace (code + " isValid : " + Luhn.isValid(code)) ;
 * }
 * </p>
 * @see <a href='http://fr.wikipedia.org/wiki/Formule_de_Luhn'>Luhn Formula</a> 
 * @author eKameleon
 */
class vegas.string.Luhn 
{

	/**
	 * Returns {@code true} if the expression in argument is a valid Luhn value.
	 * @return {@code true} if the expression in argument is a valid Luhn value.
	 */
	static public function isValid(str:String):Boolean 
	{	
		str = new String(str) ;
		var	n:Number ;
		var sum:Number = 0 ;
		var l:Number = str.length ;
		for (var i:Number = 0 ; i<l ; i++)
		{
			n = Number(str.charAt(i)) * ( i%2 == 1 ? 2 : 1) ;
			sum += n - ((n > 9) ? 9 : 0) ;
		}
		return sum%10 == 0 ;
	}

}

