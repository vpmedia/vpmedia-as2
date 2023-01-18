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

import vegas.data.iterator.Iterator;

/**
 * This interface is used to creates container components.
 * @author eKameleon
 */
interface lunas.display.components.IContainer 
{
	
	function addChild( o , oInit) ;
		
	function addChildAt(o, index:Number, oInit)  ;

	function clear():Void ;
	
	function contains( oChild ):Boolean ;
	
	function getChildAt(index:Number) ;
	
	function getChildByKey(key:Number) ;
	
	function getChildByName(name:String) ;
	
	function iterator():Iterator ;

	function indexOf( oChild ):Number ;

	function removeChild( oChild ):Void ;
	
	function removeChildAt(index:Number):Void ;
	
	function removeChildsAt(index:Number, len:Number):Void ;
	
	function removeRange(from:Number, to:Number):Void ;
	
	function setChildIndex( oChild, index:Number):Void ;
	
	function size():Number ;
	 
}