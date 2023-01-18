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

import lunas.core.AbstractBuilder;
import lunas.display.bar.VisualVScrollbarDisplay;

import vegas.events.Delegate;

/**
 * The IBuilder of the VisualVScrollbar component.
 * @author eKameleon
 */
class lunas.display.bar.VisualVScrollbarDisplayBuilder extends AbstractBuilder 
{
	
	/**
	 * Creates a new VisualVScrollbarBuilder instance.
	 */	
	function VisualVScrollbarDisplayBuilder( component:VisualVScrollbarDisplay ) 
	{
		super( component );
	}
	
	/**
	 * The bar reference.
	 */
	public var bar:MovieClip ;

	/**
	 * The target reference of the component to build.
	 */
	public var target:VisualVScrollbarDisplay ;

	/**
	 * The thumb reference.
	 */
	public var thumb:MovieClip ;
	
	/**
	 * Clear the view of the component.
	 */
	public function clear():Void 
	{
		//
	}
	
	/**
	 * Run the build of the component.
	 */
	public function run():Void 
	{
		
		bar = target.resolve("bar") ;
		bar.onPress = Delegate.create( target, target.dragging ) ;
		
		thumb = target.resolve("thumb") ;
		thumb.onPress          = Delegate.create( target , target.startDragging ) ;
		thumb.onRelease        = Delegate.create( target , target.stopDragging  ) ;
		thumb.onReleaseOutside = Delegate.create( target , target.stopDragging  ) ;

	}

	/**
	 * Update the component.
	 */
	public function update():Void 
	{
		bar._height = target.getH() ;
	}

}