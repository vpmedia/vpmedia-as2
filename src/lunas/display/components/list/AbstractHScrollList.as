/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.display.Direction;
import asgard.display.ScrollContainerPolicy;

import lunas.display.components.list.AbstractList;

/**
 * @author eKameleon
 */
class lunas.display.components.list.AbstractHScrollList extends AbstractList 
{
	
	/**
	 * Create a new AbstractHScrollList
	 */
	private function AbstractHScrollList() 
	{
		super();
		setScrollPolicy(ScrollContainerPolicy.FULL) ;
	}

	
	public function get scrollPolicy():ScrollContainerPolicy 
	{
		return getScrollPolicy() ;
	}
	
	public function set scrollPolicy(policy:ScrollContainerPolicy):Void 
	{
		setScrollPolicy(policy) ;
	}
	
	public function get hMaxPosition():Number 
	{
		return getHMaxPosition() ;	
	}
	
	public function get hPosition():Number 
	{
		return getHPosition() ;
	}
	
	public function set hPosition(n:Number):Void 
	{
		setHPosition(n) ;
	}

	public function getScrollPolicy():ScrollContainerPolicy 
	{
		return _scrollPolicy ;
	}

	public function getHMaxPosition():Number 
	{
		return getContainer().getMaxscroll() ;
	}

	public function getHPosition():Number 
	{ 
		var c:MovieClip = getContainer() ;
		return (c.getDirection() == Direction.HORIZONTAL) ? c.getScroll() : null ;
	}

	public function setScrollPolicy( policy:ScrollContainerPolicy , noRender:Boolean):Void 
	{
		_scrollPolicy = ScrollContainerPolicy.validate(policy) ? policy : ScrollContainerPolicy.FULL ;
		if (!noRender) 
		{
			update() ;
		}
	}

	public function setHPosition(n:Number, noEvent:Boolean):Void 
	{ 
		var c:MovieClip = getContainer() ;
		if (c.getDirection() == Direction.HORIZONTAL) 
		{
			c.setScroll(n, noEvent) ;
		}
	}
 	
	private var _scrollPolicy:ScrollContainerPolicy ;
	
}