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
import com.bumpslide.util.*;

class com.bumpslide.data.ModelBinding
{
	
	private var model				: Model;
	private var propName			: String;
	private var target				: Object;
	private var targetPropName		: String;
	private var targetFunction     : Function;
	private var _bound = false;

	
	function ModelBinding(m:Model, p:String, t:Object, setterOrFunction  )
	{		
		// if no callback setter name or function is provided, call the
		// setter with name the same as the key we are watching
		if(setterOrFunction==null) setterOrFunction=p;
		
		if(m==null || p==null || t==null)  {
			
			Debug.error('Unable to create ModelBinding from "'+propName+'" to '+target);	
			
		} else {
			
			model = m;
			propName = p;
			target = t;		

			if(typeof(setterOrFunction)=='function') {
				targetPropName = null;
				targetFunction = setterOrFunction;				
			} else {
				targetPropName = setterOrFunction;
				targetFunction = null;
			}	
			
			_bound = true;
			
			// bootstrap to initial state
			executeBinding();
			
			// listen to value change events
			model.registerBinding( this );
			model.addEventListener( Model.VALUE_CHANGED_EVENT, this );		
		}		
	}
	
	function get modelProp () : String {
		return propName;
	}
	function get targetObject () {
		return target;
	}
	
	function get bound () {
		return _bound;
	}
	
	function unbind() {
		//Debug.warn('Removing Binding for '+propName+' from '+target._name);
		model.removeEventListener( Model.VALUE_CHANGED_EVENT, this );
		_bound = false;
	}	
	
	private function onValueChanged ( evt:ModelValueChangedEvent ) {
		if(evt.key==propName) {
			executeBinding(evt.newValue, evt.oldValue);
		}
	}
	
	private function executeBinding(newValue, oldValue) {
		
		if(newValue==undefined) {
			newValue=model.get(propName);
		}
		if(target==undefined) {
			Debug.warn('Unbinding orphaned ModelBinding');
			// notify model (so it can remove this binding from it's list)
			model.unregisterBinding( this );
			unbind();
		} else if(targetPropName!=null) {
			// callback as setter
			target[targetPropName] = newValue;
		} else if (targetFunction!=null) {
			// callback as function
			targetFunction.call( target, newValue, oldValue );
		}
	}
	
	
	
	
}
