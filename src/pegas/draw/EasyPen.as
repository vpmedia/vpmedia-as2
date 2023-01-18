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

import pegas.draw.AbstractPen;
import pegas.draw.Align;

/**
 * This pen is the basic tool to draw in a MovieClip reference.
 * @author eKameleon
 */
class pegas.draw.EasyPen extends AbstractPen 
{

	/**
	 * Creates a new EasyPen instance.
	 */
	public function EasyPen(target:MovieClip, isNew:Boolean) 
	{
		initialize(target, isNew) ;
	}

	public function get align():Number 
	{
		return getAlign() ;	
	}
	
	public function set align(nAlign:Number):Void 
	{
		setAlign(nAlign) ;	
	}

	/**
	 * Indique en cas de besoin si la méthode draw finie par un endFill() ou non.
	 */
	public var isEndFill:Boolean = true ;

	public function getAlign():Number 
	{
		return _align ;
	}

	public function setAlign ( nAlign:Number , noDraw:Boolean):Void 
	{
		_align = (Align.validate(nAlign)) ? nAlign : Align.TOP_LEFT ;
		if (!noDraw) draw() ;
	}

	private var _align:Number ;
	
}