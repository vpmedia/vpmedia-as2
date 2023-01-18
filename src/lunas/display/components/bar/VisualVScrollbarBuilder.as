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

import lunas.display.components.AbstractBuilder;

import vegas.events.Delegate;

/**
 * The IBuilder of the VisualVScrollbar component.
 * @author eKameleon
 */
class lunas.display.components.bar.VisualVScrollbarBuilder extends AbstractBuilder 
{
	
	/**
	 * Creates a new VisualVScrollbarBuilder instance.
	 */	
	function VisualVScrollbarBuilder(mc : MovieClip) 
	{
		super(mc);
	}
	
	public var bar:MovieClip ;

	public var thumb:MovieClip ;
	
	public function clear():Void 
	{
		//
	}

	public function run():Void 
	{
		_createBar() ;
		_createThumb() ;
	}

	public function update():Void 
	{
		bar._height = target.getH() ;
	}

	private function _createBar():Void 
	{
		bar = target.bar ;
		bar.onPress = Delegate.create(target, target.dragging) ;
		bar.useHandCursor = false ;
	}

	private function _createThumb():Void 
	{
		thumb = target.thumb ;
		thumb.onPress = Delegate.create(target, target.startDragging) ;
		thumb.onRelease = Delegate.create(target, target.stopDragging) ;
		thumb.onReleaseOutside = thumb.onRelease ;
		thumb.useHandCursor = false ;
	}

}