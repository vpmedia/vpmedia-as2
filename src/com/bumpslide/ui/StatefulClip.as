/**
 *  Copyright (c) 2006, David Knape and contributing authors
 *
 *  Permission is hereby granted, free of charge, to any person 
 *  obtaining a copy of this software and associated documentation 
 *  files (the "Software"), to deal in the Software without 
 *  restriction, including without limitation the rights to use, 
 *  copy, modify, merge, publish, distribute, sublicense, and/or 
 *  sell copies of the Software, and to permit persons to whom the 
 *  Software is furnished to do so, subject to the following 
 *  conditions:
 *  
 *  The above copyright notice and this permission notice shall be 
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

 
import com.bumpslide.data.*;

/**
 *  Abstract Class for defining clips that can responds to specific view state changes 
 */
 
class com.bumpslide.ui.StatefulClip extends com.bumpslide.ui.BaseClip
{
	
	private var stateSubscriptions:Array;	
		
	
	/**
	 *  This must return a valid state model
	 */
	function get state () : Model {
		// for example:
		// return myapp.ModelLocator.viewState;		
		return null;		
	}
	
	
	/**
	 *  Init state after running superclass version of onLoad 
	 */
	function onLoad() {	
		
		super.onLoad();		
		
		if(state==null) return;
	
		// listen to state value changes
		state.addEventListener( Model.VALUE_CHANGED_EVENT, delegate( this, onStateValueChange));		
	
		// call change handlers for subscribed state vars
		for(var n=0; n<stateSubscriptions.length; n++) {			
			var key = stateSubscriptions[n];
			callChangeHandler(key, state.get(key));
		}			
	}
			
	
	/**
	 * When a state value changes, call the change handler for that key
	 * 
	 * @param	e 
	 */
	function onStateValueChange( e:ModelValueChangedEvent ) {
		//trace('[StatefulClip] onStateValueChange');
		callChangeHandler( e.key, e.newValue, e.oldValue );
	}
	
	/**
	* Calls the change handler function for a given key
	* Change handlers are function with names formed using the convention 
	* "onStateChange_"+key
	* 
	* @param	key
	* @param	oldValue
	* @param	newValue
	*/
	function callChangeHandler( key:String, newValue, oldValue) {
		var changeHandler = this['onStateChange_'+key];
		if(changeHandler!==undefined && typeof(changeHandler)=='function') {
			changeHandler.call( this, newValue, oldValue );		
		}
	}
}
