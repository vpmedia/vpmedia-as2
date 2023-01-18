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

/**
 * Defines a type of DisplayObject that indicates a loading in progress.
 * @author eKameleon
 */
interface andromeda.display.abstract.ILoaderDisplay 
{
	
	/**
	 * Returns the label value.
	 * @return the label value.
	 */
	function getLabel():String ;
	
	/**
	 * Returns the percent of the loader in percent.
	 * @return the percent of the loader in percent.
	 */
	function getPercent():Number ;

	/**
	 * Hide the display.
	 */
	function hide():Void ;

	/**
	 * Returns {@code true} if the display is visible.
	 * @return {@code true} if the display is visible.
	 */
	function isVisible():Boolean ; 

	/**
	 * Resets the loader.
	 */
	function reset():Void ;
	
	/**
	 * Set the label value.
	 */
	function setLabel(s:String):Void ;
	
	/**
	 * Sets the label and the percent values of the loader display.
	 * @param message the value of the message to show.
	 * @param percent the value of the percent position of this loader.
	 */
	function setLoader( message, percent:Number ):Void ;
	
	/**
	 * Sets the percent of the loader in percent.
	 */
	function setPercent(n:Number):Void ;

	/**
	 * Update the display.
	 */	
	function update():Void ;

	/**
	 * Show the display.
	 */
	function show():Void ;
	
}