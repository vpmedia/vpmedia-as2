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

/**
 * This interface defines a label control displays a single line of noneditable text. 
 * Use the Text control to create blocks of multiline noneditable text.
 * @author eKameleon
 */
interface lunas.core.ILabel 
{
	
	/**
	 * Returns the automatic sizing and alignment of labels value.
	 * @return the automatic sizing and alignment of labels value.
	 * @see TextFieldAutoSize
	 */
	function getAutoSize():String ;
	
	/**
	 * Returns a flag that indicates whether the text field contains an HTML representation.
	 * @return a flag that indicates whether the text field contains an HTML representation.
	 */
	function getHTML():Boolean ;
	
	/**
	 * Returns the string representation of the label.
	 * @return the string representation of the label.
	 */
	function getLabel():String ;

	/**
	 * Returns if the label is a multiline label.
	 * @return if the label is a multiline label.
	 */
	function getMultiline():Boolean ;

	/**
	 * Returns the string text representation of the label.
	 */
	function getText():String ;
	
	/**
	 * Sets the automatic sizing and alignment of labels.
	 */
	function setAutoSize(b:String):Void ;
	
	/**
	 * Sets a flag that indicates whether the text field contains an HTML representation.
	 * @param b The flag that indicates whether the text field contains an HTML representation. 
	 */
	function setHTML(b:Boolean):Void ;
	
	/**
	 * Sets the string representation of the label.
	 */
	function setLabel(str:String):Void ;
	
	/**
	 * Sets if the label is a multiline label.
	 */
	function setMultiline(b:Boolean):Void ;
	
	/**
	 * Sets the string text representation of the label.
	 */
	function setText(str:String):Void ;


}