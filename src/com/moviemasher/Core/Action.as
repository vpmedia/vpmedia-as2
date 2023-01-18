/*
* The contents of this file are subject to the Mozilla Public
* License Version 1.1 (the "License"); you may not use this
* file except in compliance with the License. You may obtain a
* copy of the License at http://www.mozilla.org/MPL/
* 
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
* or implied. See the License for the specific language
* governing rights and limitations under the License.
* 
* The Original Code is 'Movie Masher'. The Initial Developer
* of the Original Code is Doug Anarino. Portions created by
* Doug Anarino are Copyright (C) 2007 Syntropo.com, Inc. All
* Rights Reserved.
*/



/** Class provides mechanism for undo/redo history.
*/

class com.moviemasher.Core.Action
{
// PUBLIC CLASS PROPERTIES

	static var doStack : Array = [];
	static var currentDo : Number = -1;

// PUBLIC CLASS METHODS

	static function clear() : Void
	{
		doStack = [];
		currentDo = -1;
		_global.app.dispatchEvent({type: 'action', action: undefined});
	}

	static function factory(redofunction : Function, undofunction : Function, props : Object, done : Boolean) : Action
	{
		var new_action = new Action();
		if (props != undefined)
		{
			for (var k in props) { new_action[k] = props[k]; }
		}
		new_action.__redoFunction = redofunction;
		new_action.__undoFunction = undofunction;
		
		if (currentDo < doStack.length - 1) 
		{
			doStack.splice(currentDo + 1, doStack.length - currentDo);
		}
		doStack.push(new_action);
		redo(done, true);
		return new_action;
	}
	
	static function redo(done : Boolean) : Void
	{
		if (currentDo < doStack.length - 1)
		{
			currentDo ++;
			var dofunction = doStack[currentDo];
			if (! done) dofunction.__redoFunction();
			_global.app.dispatchEvent({type: 'action', action: dofunction});
		}
	}
	static function undo() : Void
	{
		if (currentDo > -1)
		{
			var dofunction = doStack[currentDo];
			dofunction.__undoFunction();
			currentDo --;
			_global.app.dispatchEvent({type: 'action', action: dofunction});
		}
	}
	
// PRIVATE INSTANCE PROPERTIES

	private var __redoFunction : Function;
	private var __undoFunction : Function;


// PRIVATE INSTANCE METHODS
	private function Action()
	{
	
	}
	

}