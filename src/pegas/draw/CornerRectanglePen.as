/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.draw.Corner;
import pegas.draw.RectanglePen;

/**
 * This pen is the basic tool to corner rectangle in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.CornerRectanglePen extends RectanglePen 
{

	/**
	 * Creates a new CornerRectanglePen instance. Overrides this constructor to used it.
	 */
	private function CornerRectanglePen(target:MovieClip, isNew:Boolean) 
	{
		super(target, isNew) ;
	}

	public function get corner():Corner 
	{
		return getCorner() ;
	}
	
	public function set corner(c:Corner):Void 
	{
		setCorner(c) ;
	}

	public function getCorner():Corner 
	{
		return _corner || new Corner() ;
	}
	
	public function setCorner(c:Corner , noDraw:Boolean):Void 
	{
		_corner = c ;
		if (!noDraw) draw() ;
	}

	private var _corner:Corner ;

}