/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- AbstractBuilder

	AUTHOR
		
		Name : AbstractBuilder
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2006-02-05
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		private

	PROPERTY SUMMARY
	
		- target:MovieClip

	METHOD SUMMARY
	
		- clear():Void
		
		- execute(e:IEvent):Void
		
		- toString():String
		
		- update():Void

	INHERIT
	
		Object
			|
			CoreObject
				|
				AbstractBuilder

	TODO :: Créer un proxy via ResolverProxy sur le target !

-------------- */

import com.bourre.events.IEvent;

import neo.core.CoreObject;
import neo.display.components.IBuilder;

class neo.display.components.AbstractBuilder extends CoreObject implements IBuilder {
	
	// ----o Constructor

	private function AbstractBuilder( mc:MovieClip ) {
		target = mc ;
	}

	// ----o Public Properties
	
	public var target:MovieClip ;
	
	// ----o Public Methods

	public function clear():Void {
		// override
	}
	
	public function execute(e:IEvent):Void {
		// override
	}

	public function getTarget():MovieClip {
		return target ;
	}
	
	public function setTarget(t:MovieClip):Void {
		target = t ;
	}
	
	public function update():Void {
		// override
	}

}