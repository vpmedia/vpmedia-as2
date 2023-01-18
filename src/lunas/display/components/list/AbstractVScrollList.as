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
class lunas.display.components.list.AbstractVScrollList extends AbstractList 
{
	
	/**
	 * Create a new AbstractVScrollList
	 */
	private function AbstractVScrollList() 
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
	
	public function get vMaxPosition():Number 
	{
		return getVMaxPosition() ;	
	}
	
	public function get vPosition():Number 
	{
		return getVPosition() ;
	}
	
	public function set vPosition(n:Number):Void 
	{
		setVPosition(n) ;
	}

	public function getScrollPolicy():ScrollContainerPolicy 
	{
		return _scrollPolicy ;
	}

	public function getVMaxPosition():Number 
	{
		return getContainer().getMaxscroll() ;
	}

	public function getVPosition():Number 
	{ 
		var c:MovieClip = getContainer() ;
		return (c.getDirection() == Direction.VERTICAL) ? c.getScroll() : null ;
	}

	public function setScrollPolicy( policy:ScrollContainerPolicy , noRender:Boolean):Void 
	{
		_scrollPolicy = ScrollContainerPolicy.validate(policy) ? policy : ScrollContainerPolicy.FULL ;
		if (!noRender) 
		{
			update() ;
		}
	}

	public function setVPosition(n:Number, noEvent:Boolean):Void 
	{ 
		var c:MovieClip = getContainer() ;
		if (c.getDirection() == Direction.VERTICAL) 
		{
			c.setScroll(n, noEvent) ;
		}
	}
 	
	private var _scrollPolicy:ScrollContainerPolicy ;
	
}