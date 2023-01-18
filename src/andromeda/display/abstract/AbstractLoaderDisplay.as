/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.display.abstract.ILoaderDisplay;

import asgard.display.ConfigurableDisplayObject;

import pegas.maths.Range;

/**
 * The abstract class of all loader displays in the application.
 * @author eKameleon
 */
class andromeda.display.abstract.AbstractLoaderDisplay extends ConfigurableDisplayObject implements ILoaderDisplay 
{
	
	/**
	 * Abstract constructor, this constructor must be override.
	 * @param sName the name of the display.
	 * @param target the DisplayObject instance control this target.
	 * @param depth the depth of the view reference of this display.
	 */
	public function AbstractLoaderDisplay( sName:String , target , depth:Number ) 
	{
		super( sName , target.createEmptyMovieClip( sName, depth )  ) ;
	}

	/**
	 * Returns the label value.
	 * @return the label value.
	 */
	public function get label():String
	{
		return getLabel() ;
	}
	
	/**
	 * Set the label value.
	 */
	public function set label(s:String):Void
	{
		setLabel(s) ;
	}

	/**
	 * Returns the percent of the loader in percent.
	 * @return the percent of the loader in percent.
	 */
	public function get percent():Number
	{
		return getPercent() ;
	}
	
	/**
	 * Sets the percent of the loader in percent.
	 */
	public function set percent(n:Number):Void
	{
		setPercent(n) ;
	}

	/**
	 * Returns the label value.
	 * @return the label value.
	 */
	public function getLabel():String
	{
		return _label ;
	}
	
	/**
	 * Returns the percent of the loader in percent.
	 * @return the percent of the loader in percent.
	 */
	public function getPercent():Number
	{
		return _percent ;
	}

	/**
	 * Resets the loader.
	 */
	public function reset():Void
	{
		_label    = null ;
		_percent = 0 ;
		update() ;	
	}
	
	/**
	 * Set the label value.
	 */
	public function setLabel(s:String):Void
	{
		_label = s ;
		update() ;	
	}
	
	/**
	 * Sets the label and the percent values of the loader display.
	 * @param message the value of the message to show.
	 * @param percent the value of the percent position of this loader.
	 */
	public function setLoader( message, percent:Number ):Void
	{
		_label   = message.toString() || null ;
		_percent = Range.PERCENT_RANGE.clamp( (percent>0) ? percent : 0 ) ;
		update() ;
	}
	
	/**
	 * Sets the percent of the loader in percent.
	 */
	public function setPercent(n:Number):Void
	{
		_percent = Range.PERCENT_RANGE.clamp( (n>0) ? n : 0 ) ;
		update() ;
	}

	/**
	 * Update the display.
	 */	
	public function update():Void
	{
		// overrides this method.
	}
	
	/**
	 * Show the display.
	 */
	/*override*/ public function show():Void
	{
		reset() ;
		super.show() ;
	}

	/**
	 * The internal label value of this loader display.
	 */
	private var _label:String ;
	
	/**
	 * The internal position value of this loader display.
	 */
	private var _percent:Number = 0 ;
	
}