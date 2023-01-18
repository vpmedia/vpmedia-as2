
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

import vegas.util.ArrayUtil ;

/**
 * The Video codec ID number enumeration class.
 * <p>More informations in the <a href='http://www.buraks.com/flvmdi/'>flvmdi page</a> write by Burak.</p>
 * @author eKameleon
 * @see FLVMetaData
 */
class asgard.media.VideoCodec 
{

	/**
	 * The first value of the On2 VP6 video codec.
	 */
	static public var ON2_VP6_1:Number = 4 ; 

	/**
	 * The second value of the On2 VP6 video codec.
	 */
	static public var ON2_VP6_2:Number = 5 ; 

	/**
	 * The 'Screen Video' video id value.
	 */
	static public var SCREEN_VIDEO:Number = 3 ;

	/**
	 * The 'Screen Video' V2 video id value.
	 */
	static public var SCREEN_VIDEO_V2:Number = 6 ;
	
	/**
	 * The 'Sorenson H.263' video id value.
	 */
	static public var SORENSON:Number = 2 ;
	
	/**
	 * Returns {@code true} if the specified id in argument is a valid video codec.
	 * @return {@code true} if the specified id in argument is a valid video codec.
	 */
	public function validate( id:Number ):Boolean
	{
		var ar:Array = [ ON2_VP6_1, ON2_VP6_2, SCREEN_VIDEO, SCREEN_VIDEO_V2 , SORENSON] ;
		return 	ArrayUtil.contains(ar, id) ;
	}

}