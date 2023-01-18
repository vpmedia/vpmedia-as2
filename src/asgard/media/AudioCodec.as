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

import vegas.util.ArrayUtil;

/**
 * The Audio codec ID number enumeration class.
 * <p>More informations in the <a href='http://www.buraks.com/flvmdi/'>flvmdi page</a> write by Burak.</p>
 * @author eKameleon
 * @see FLVMetaData
 */
class asgard.media.AudioCodec 
{
	
	/**
	 * The ADPCM audio codec value.
	 */
	static public var ADPCM:Number = 1 ;

	/**
	 * The MP3 audio codec value.
	 */
	static public var MP3:Number = 2 ;

	/**
	 * The first NellyMoser audio codec value.
	 */
	static public var NELLY_MOSER_1:Number = 5 ;

	/**
	 * The second NellyMoser audio codec value.
	 */
	static public var NELLY_MOSER_2:Number = 6 ;

	/**
	 * The Uncompressed audio codec value.
	 */
	static public var UNCOMPRESSED:Number = 0 ;
	
	/**
	 * Returns {@code true} if the specified id in argument is a valid audio codec.
	 * @return {@code true} if the specified id in argument is a valid audio codec.
	 */
	public function validate( id:Number ):Boolean
	{
		var ar:Array = [ ADPCM, MP3, UNCOMPRESSED, NELLY_MOSER_1 , NELLY_MOSER_2] ;
		return 	ArrayUtil.contains(ar, id) ;
	}

}
