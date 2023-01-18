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

import asgard.net.remoting.RemotingService;

import vegas.core.CoreObject;
import vegas.core.IFormat;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.util.TypeUtil;

/**
 * The instances of this class can converts an object to a custom string representation.
 * @author eKameleon
 */
class asgard.net.remoting.RemotingFormat extends CoreObject implements IFormat 
{

	/**
	 * Creates a new RemotingFormat instance.
	 */
	public function RemotingFormat() 
	{
		//
	}

	/**
	 * Converts the object to a custom string representation.
	 */	
	public function formatToString(o):String 
	{
		var rs:RemotingService = RemotingService(o);
		var r = rs.getResult() ;
		var txt:String = "[" ;
		if (rs.getServiceName()) txt += "\r\tserviceName : " + rs.getServiceName() + " , " ;
		if (rs.getMethodName()) txt += "\r\tmethodName : " + rs.getMethodName() + " ," ;
		if (rs.getServiceName()) txt += "\r\tresult : " ;
		if (r != undefined)
		{
			if (r instanceof Iterable) 
			{
				txt += "[\r" ;
				var it:Iterator = r.iterator() ;
				while ( it.hasNext() ) 
				{
					var item = it.next() ;
					if (TypeUtil.isExplicitInstanceOf( item, Object ) )
					{
						txt += "\t[\r" ;
						for (var prop:String in o) 
						{
							txt += "\t\t " + prop + " : " + item[prop] + "\r" ;
						}
						txt += "\t] " ; 
						txt += ( it.hasNext() ) ? "," : "" ;
						txt += "\r" ;
					}
					else
					{
						txt += "\t" + item + "\r" ;
					}
				}	
			} 
			else 
			{
				txt += r  + "\r";
			}
			txt += "]" ;
		} 
		else 
		{
			txt += "empty";
			if (rs.getServiceName() || rs.getMethodName()) txt += "\r" ;
			txt += "]" ;
		}
		return txt ;
	}
	
}