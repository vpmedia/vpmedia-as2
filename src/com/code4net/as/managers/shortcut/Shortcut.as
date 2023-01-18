/**
 *  Copyright (C) 2006 Xavi Beumala
 *  
 *	This program is free software; you can redistribute it and/or modify 
 *	it under the terms of the GNU General Public License as published by 
 *	the Free Software Foundation; either version 2 of the License, or 
 *	(at your option) any later version.
 *	
 *	This program is distributed in the hope that it will be useful, but 
 *	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 *	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 *	for more details.
 *	
 *	You should have received a copy of the GNU General Public License along
 *	with this program; if not, write to the Free Software Foundation, Inc., 59 
 *	Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *	
 *  @author Xavi Beumala
 *  @link http://www.code4net.com
 */
 
import com.code4net.as.dataTypes.HashMap;
import com.code4net.as.iterators.LinearIterator;
import com.code4net.as.patterns.ICommand;

class com.code4net.as.managers.shortcut.Shortcut implements ICommand {
	private var key:Number;
	private var holdKeys:LinearIterator;
	private var action:ICommand;
	private var actionParamaters:Object;
	
	public function Shortcut(action:ICommand,actionParameters:Object,holdKeys:Array,key) {
		this.action = action;
		this.actionParamaters = actionParameters;
		this.holdKeys = new LinearIterator(holdKeys);

		if (typeof(key) == "number") {
			this.key = key;
		} else if (typeof(key) == "string") {
			this.key = String(key).toUpperCase().charCodeAt(0);
		}
	}
	
	private function checkHoldKeys():Boolean {
		holdKeys.gotoElement(-1);
		
		while (holdKeys.hasNext()) {
			if (!Key.isDown(holdKeys.getNextElement())) {
				return false;
			}
		}
		
		return true;
	}
	
	private function checkKeyCode():Boolean {
		if (Key.getCode() == key || key == null) {
			return true;
		}
		
		return false;
	}
	
	public function check():Boolean {
		return checkHoldKeys() && checkKeyCode();
	}
	

	public function execute(params:Object) {
		action.execute(actionParamaters);
	}

	public function toString() {
		var dictionary = new HashMap();
		dictionary.put (Key.CONTROL, "CTRL");
		dictionary.put (Key.SHIFT, "SHIFT");
		dictionary.put (Key.ALT, "ALT");
		
		var returnValue = new String();
		
		while (holdKeys.hasNext()) {
			returnValue += dictionary.get(holdKeys.getNextElement()) + " + ";
		}
		
		return returnValue + String.fromCharCode(key);
	}
}