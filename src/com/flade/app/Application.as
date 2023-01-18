/**
 * Flade - Flash Dynamics Engine
 * Release 0.4 alpha 
 * Graphics class
 * Copyright 2004, 2005 Alec Cove
 * 
 * This file is part of Flade. The Flash Dynamics Engine. 
 *	
 * Flade is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Flade is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Flade; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Flash is a registered trademark of Macromedia
 */
 
 
 import com.flade.app.Runnable
 import com.flade.app.Timeline
 
/**
 *	
 *	@author	Younes benaomar <a href="http://blog.locobrain.com">http://blog.locobrain.com</a>
 *	@version	1.0
 *	@since	
 *	@history	
 *	      	
 */
class com.flade.app.Application implements Runnable 
{	
	private var scope: MovieClip;	
	private var width: Number;
	private var height: Number;
	
	
	public function Application(scope:MovieClip, width: Number, height: Number )
	{
		_focusrect = false;
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		Stage.showMenu = false;
		
		this.scope = scope
		this.width = width || Stage.width;
		this.height = height || Stage.height;
		
		var timeline:Timeline = new Timeline(scope);
		timeline.addTimelineListener(this);
		timeline.resume();
		Key.addListener(this);
				
	}
	
	function run() 
	{ 
		trace("ini");
	}
    
	public function getWidth(): Number
	{
		return width;
	}
	
	public function getHeight(): Number
	{
		return height;
	}
	
	public function getScope(): MovieClip
	{
		return scope;
	}
	
	
}