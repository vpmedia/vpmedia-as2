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

import lunas.core.Iconifiable;
import lunas.display.abstract.AbstractButtonDisplay;

import pegas.colors.ColorUtil;
import pegas.events.ButtonEvent;
import pegas.events.ButtonEventType;

/**
 * This abstract class determinates the skeletal implementation to implement an icon button displays.
 * @author eKameleon
 */
class lunas.display.abstract.AbstractButtonIconDisplay extends AbstractButtonDisplay implements Iconifiable
{

	/**
	 * Creates a AbstractButtonIconDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	private function AbstractButtonIconDisplay ( sName:String, target:MovieClip ) 
	{
		super ( sName, target ) ;
	}

	/**
	 * The default icon depth of this display. 
	 */
	static public var DEFAULT_ICON_DEPTH:Number = 100 ;
	
	/**
	 * (read-write) Returns a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 * To create a custom icon, create a movie clip or graphic symbol. 
	 * Select the symbol on the Stage in symbol-editing mode and enter 0 in both the X and Y boxes in the Property inspector. 
	 * In the Library panel, select the movie clip and select Linkage from the Library pop-up menu. 
	 * Select Export for ActionScript, and enter an identifier in the Identifier text box.
	 * The default value is an empty string, which indicates that there is no icon.
	 */
	public function get icon():String 
	{
		return getIcon() ;	
	}

	/**
	 * (read-write) Sets a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 * To create a custom icon, create a movie clip or graphic symbol. 
	 * Select the symbol on the Stage in symbol-editing mode and enter 0 in both the X and Y boxes in the Property inspector. 
	 * In the Library panel, select the movie clip and select Linkage from the Library pop-up menu. 
	 * Select Export for ActionScript, and enter an identifier in the Identifier text box.
	 * The default value is an empty string, which indicates that there is no icon.
	 */
	public function set icon(sIcon:String):Void 
	{
		setIcon(sIcon) ;	
	}
	
	/**
	 * Attach and returns a new Icon in the component.
	 * @param depth (optional) the depth of the icon (default value is the constant DEFAULT_ICON_DETH)
	 * @param target (optional) the other scope parent reference of the icon.
	 * @param name (optional) the name of the view icon reference.
	 * @return a new Icon MovieClip reference attached in the view or the specified scope.
	 */
	public function attachIcon( depth:Number, target:MovieClip , name:String ):MovieClip 
	{
		
		if (getIconTarget() != null) 
		{
			getIconTarget().removeMovieClip() ;
		}
		
		if (getIcon() != undefined) 
		{
		
			if (target == null)
			{
				target = view ;
			}
			
			depth = isNaN(depth) ? DEFAULT_ICON_DEPTH : depth ;
			
			if (name == null)
			{
				name = "icon" + depth ;	
			}
			
			return target.attachMovie( getIcon(), name, depth ) || null ;
		
		} 
		else 
		{
			return null ;
		}
	}

	/**
	 * (read-write) Returns a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 * To create a custom icon, create a movie clip or graphic symbol. 
	 * Select the symbol on the Stage in symbol-editing mode and enter 0 in both the X and Y boxes in the Property inspector. 
	 * In the Library panel, select the movie clip and select Linkage from the Library pop-up menu. 
	 * Select Export for ActionScript, and enter an identifier in the Identifier text box.
	 * The default value is an empty string, which indicates that there is no icon.
	 * @return a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 */
	public function getIcon():String 
	{ 
		return _sIcon ;
	}
	
	/**
	 * Returns the depth value of the icon.
	 * @return the depth value of the icon.
	 */
	public function getIconDepth():Number 
	{ 
		return getIconTarget().getDepth() ;
	}
	
	/**
	 * Returns the MovieClip reference of the icon.
	 */
	public function getIconTarget():MovieClip 
	{ 
		return _mcIcon ;
	}

	/**
	 * Reset the color effect over the icon.
	 */
	public function resetIconColor():Void 
	{
		if ( getIconTarget()) 
		{
			ColorUtil.reset(new Color(_mcIcon)) ;
		}
	}

	/**
	 * Sets a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 */
	public function setIcon( str:String ) : Void 
	{
		_sIcon = str ; 
		viewIconChanged() ;
		dispatchEvent(new ButtonEvent( ButtonEventType.ICON_CHANGE )) ;
	}

	/**	
	 * Sets the icon color of this component.
	 * @see Color.setRGB
	 */
	public function setIconColor(hex:Number):Void 
	{
		resetIconColor() ; 
		if ( _mcIcon && !isNaN(hex) ) 
		{
			(new Color(_mcIcon)).setRGB (hex) ;
		}
	}

	/**
	 * Sets the icon reference of this component.
	 */
	public function setIconTarget( target:MovieClip ):Void
	{ 
		_mcIcon = target ;
	}

	/**
	 * Invoqued when the icon property is changed.
	 */
	public function viewIconChanged():Void 
	{
		// override this method when icon property change
	}
	
	private var _mcIcon:MovieClip ;

	private var _sIcon:String ;
	

}
