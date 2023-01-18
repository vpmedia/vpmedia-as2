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
interface lunas.display.components.ILabel 
{

	function getAutoSize():Boolean ;
	
	function getHTML():Boolean ;
	
	function getLabel():String ;
	
	function getMultiline():Boolean ;
	
	function getText():String ;
	
	function setAutoSize(b:Boolean):Void ;
	
	function setHTML(b:Boolean):Void ;
	
	function setLabel(str:String):Void ;
	
	function setMultiline(b:Boolean):Void ;
	
	function setText(str:String):Void ;


}