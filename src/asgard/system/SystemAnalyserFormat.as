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

import asgard.system.SystemAnalyser;

import vegas.core.IFormat;
import vegas.data.iterator.ArrayIterator;

/**
 * This IFormat class can converts a SystemAnalyser instance to a custom string representation.
 * @author eKameleon
 */
class asgard.system.SystemAnalyserFormat implements IFormat 
{

	/**
	 * Creates a new SystemAnalyserFormat instance.
	 */
	public function SystemAnalyserFormat() {}
		
	/**
	 * Converts the object to a custom string representation.
	 */	
	public function formatToString(o):String 
	{
		var s:SystemAnalyser = SystemAnalyser(o) ;
		var it:ArrayIterator = new ArrayIterator(s.properties) ; 
		var txt:String = "[SystemAnalyser : " ;
        while(it.hasNext()) 
        { 
            var cur:String = it.next() ; 
			txt += "\r\t" + cur + " : " + System.capabilities[cur] ; 
        } 
		txt += "\r]" ;
		return txt ;
	}
	
}