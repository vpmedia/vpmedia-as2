import com.bumpslide.data.*;
import com.bumpslide.util.*;
import mx.events.EventDispatcher;

/**
* This class represents an observable mapping of key value pairs
* 
* <p>Primitive Map with additional functionality:
* 1 - ability to add getters/setter for all mapped values
* 2 - ability to watch for changes via dispatched events
* 
* <p>This class was built to provide state management functionality. 
* 
* <p>Sample setup in Model Locator:
* {@code
* 	var stateVars:Object = {
* 		section: 1,
* 		selectedIds: [] 		
*   } 
*   ModelLocator.state = new Model( stateVars, 'myappstate' );
* 
* }
* 
* <p>Changing state using ObjectProxy-like getter/setter interface:
* {@code
* 	function onButtonPress() {
* 		// If this changes the state, then events will be broadcast to listeners
* 		ModelLocator.state.section = 2;
* 	} 
* } 
* 
* <p>Listening to changes in some other class:
* {@code   
*   function init() {
* 		ModelLocator.state.addEventListener( Model.VALUE_CHANGED_EVENT, Delegate.create( this, modelValueChanged ) );
* 	}
* 
* 	function modelValueChanged( e:ModelValueChangedEvent ) {
* 		trace( e.key +' has changed from '+e.oldValue +' to '+e.newValue);
*   }    
* }
* 
* <p>Responding to model changes in the view using binding:
* {@code 
*   // Some view clip...
*   function onLoad() {
* 		ModelLocator.state.bind( 'section', this );
* 	}
* 
*   // when section changes, this setter gets called 
*   function set section (n) {
* 		trace('Section is now '+n);
*		// update view now
*   }
* }
* 
* Copyright (c) 2006, David Knape
* Released under the open-source MIT license. 
* See LICENSE.txt for full license terms.
* 
* @author David Knape
*/

dynamic class com.bumpslide.data.Model extends com.bumpslide.data.Map {
	
	public var debug:Boolean = false;
	
	// EVENTS...
	static var VALUE_CHANGED_EVENT : String = "onValueChanged";
	static var MODEL_CHANGED_EVENT : String = "onModelChanged";
	static var CHANGE_REQUEST_EVENT : String = "onValueChangeRequest";
	
	// Private Vars
	private var _previousMap : Object;			// previously broadcasted values
	private var _dispatchInt : Number = -1;	// interval
	private var _modelName : String = "unidentified_model";
	private var _bindings:Array;
		
	// EventDispatcher mix-in functions
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	/**
	 * Creates a new observable model (object proxy) from an anonymous source object
	 * 
	 * <p>The model will be created using all enumerable properties in the source object.
	 * That is, we are using a for ... in loop on the source object, so new instances
	 * of methodless value objects may not work here.  If you want to use a specific class
	 * as the source object, then be sure to set all properties with default values in the 
	 * constructor of that class to make sure that all of those properties become enumerable.
	 * Otherwise, just use an anonymous object (curly braces) as the source.
	 * 
	 * <p>see Flash help regarding "Object.isPropertyEnumerable" and "for..in statement" for 
	 * more info on property enumerability.
	 * 
	 * <p>The second parameter is simply a string-based name for this model.  It is optional.
	 *  
	 * @param	source object
	 * @param	modelName for reference in debug statements
	 */
	function Model(source, modelName:String) 
	{
		// populate model via parent constructor
		super(source);	
		
		// make us a dispatcher
		EventDispatcher.initialize( this );
		
		// set name
		if(modelName!=null) _modelName = modelName;
		
		// init previous map object and bindings array
		_previousMap = new Object();	
		_bindings = new Array();
		
		// hide our internals from the outside world, so this looks like the source object
		var hiddenProps = ['_previousMap', 'values', 'keys', 'indexMap', 'map', '_dispatchInt','dispatchQueue', 'dispatchEvent','removeEventListener', 'addEventListener', '_modelName','_bindings'];
		_global.ASSetPropFlags( this, hiddenProps, 1);
		
		// create shortcut getters and setters 
		createAccessors();			
	}
	
	
	/**
	 * Adds getters and setters to the model for every {@code key}
	 */
	public function createAccessors() 
	{
		var n = size();
		dTrace('Creating '+n+' Getters/Setters');
		while(n--) createPropAccessors(mKeys[n]);
	}
	
	/**
	* Adds "magic" getters and setters for a given key 
	* 
	* So, if there is a key called 'screen', we can now say
	* myModel.screen += 2, and the change will still be routed through
	* our get/put functions
	* 
	* 
	* @param	key		name of getter/setter to add
	* @param 	scope   object to which we should add these accessors
	*/
	private function createPropAccessors(key:String) 
	{
		var setter = function (v){ this.put(key,v);  }
		var getter = function (){ return this.get(key); }
		
		if ( addProperty(key, getter, setter) ) {
			//dTrace('adding getter/setter for '+key);
		} else {
			dTrace('Failed to create getter/setter for '+key);
		}		
	}
		
	/**
	 * Populates the map with the content of the passed-in {@code source}.
	 * 
	 * <p>Iterates over the passed-in source with the for..in loop and uses the variables'
	 * names as key and their values as value. Variables that are hidden from for..in
	 * loops will not be added to this map.
	 * 
	 * <p>For the sake of 'Model', we have added checks for exisiting functions.
	 * 
	 * <p>This method uses the {@code put} method to add the key-value pairs.
	 * 
	 * @param source an object that contains key-value pairs to populate this map with
	 */
	private function populate(source):Void {
		dTrace('populating model from source object...');
		dTrace( source );
		if (source) {			
			for (var i in source) {
				if(typeof(source[i])!='function') {
					put(i, source[i]);
				}
			}
		}
		
	}
		
	/**
	 * Maps the given {@code key} to the {@code value}.
	 *
	 * <p>{@code null} and {@code undefined} values are allowed.
	 *
	 * @param key the key used as identifier for the {@code value}
	 * @param value the value to map to the {@code key}
	 * @return the value that was originally mapped to the {@code key} or {@code undefined}
	 */
	public function put(key, newValue) {		
		
		var oldValue = getCurrent()[key];
		
		// copy arrays to break stale references
		if(newValue instanceof Array) newValue = ArrayUtil.dCopy( newValue );
        
		switch(typeof(oldValue)) {
			case 'boolean':  newValue = (newValue==true); break;
			case 'number': newValue = Number( newValue ); break;
		}		
		
		dTrace('change request "'+key+'" = '+newValue+ '(oldValue='+oldValue+')');
		
		if( ObjectUtil.compare(oldValue, newValue) ) {	
			dTrace('oldValue==newValue, not changing');
			return oldValue;
		}
		
		// store key using super class implementation of put
		super.put(key, newValue);
		
		// hook for pre-change filters at app controller level
		dispatchEvent( new ModelValueChangeRequestEvent(this, oldValue, newValue, key) );

		// dispatch model changed events after a brief pause
		clearInterval( _dispatchInt );			
		_dispatchInt = setInterval( this, 'dispatchEvents', 10);	
		
		return oldValue;
	}
	
	/**
	 * Force a change to a state value bypassing the pre-change filters
	 * 
	 * this is needed to allow pre-change filter handlers to change values
	 * without triggering an infinite loop
	 * 
	 * @param	key
	 * @param	newValue
	 */
	public function change( key, newValue ) {
		return super.put(key, newValue);
	}
	
	// returns a read-only copy of the current map values
	public function getCurrent(Void):Object {		
		var obj = ArrayUtil.dCopy( mMap );
		_global.ASSetPropFlags(obj,mKeys,4,1);
		return obj;
	}	
	
	// returns array of keys that have changed since the last time
	// a modelChangedEvent was dispatched
	private function getChangedKeys() {
		var l = size();
		var changedKeys = [];
		var currentMap = getCurrent();
		//dTrace('finding changed keys');
		for(var i in currentMap) {	
			//dTrace('checking '+i+', comparing '+_previousMap[i]+' to '+currentMap[i]);
			if(!ObjectUtil.compare(_previousMap[i], currentMap[i])) {				
				changedKeys.push(i);
			} 
		}
		return changedKeys;
	}
	
		
	private function dispatchEvents() {	
		
		clearInterval( _dispatchInt );	
		
		var changedKeys = getChangedKeys();
		
		dTrace('Changed Keys: '+changedKeys);
		var currentMap = getCurrent();
		var modelChanged = false;
			
		dTrace('CurrentMap:')
		dTrace( currentMap );
		
		// send out value changed events
		for(var n=0; n<changedKeys.length; n++) {			
			// event dispatcher
			//trace('dispatching ModelValueChangedEvent '+changedKeys[n]+'=='+currentMap[changedKeys[n]]);
			dispatchEvent( new ModelValueChangedEvent( this, _previousMap[changedKeys[n]], currentMap[changedKeys[n]], changedKeys[n]) );
			modelChanged = true;
		}
		
		// save current values to use as old values next time
		_previousMap = currentMap;
		
		// send out model changed event
		if(modelChanged) {
			//Debug.trace('[Model] Model Changed');
			dispatchEvent( new ModelChangedEvent(this, _previousMap, currentMap, changedKeys) );
		}
				
		
	}
	
	
	//-----------------------
	// Binding interface
	//-----------------------
	
	
	/**
	* Setup a one-way binding to the model property with the key propName
	* 
	* <p>Binding will be executed whenever that property changes.
	* 
	* <p>Third parameter is optional.  By default, a setter in the target will 
	* be set with the new property value when a change occurs. 
	* The third parameter can be a string or a function.  If it is a string, 
	* then a setter with that name will be called instead of one with the name
	* of the property we are watching.  If the third argument is a function, 
	* then that function will be called is the scope of the target object.
	*  
	* @param	propName
	* @param	target
	* @param	targetPropOrFunc
	* @return
	*/
	public function bind(propName:String, target:Object, targetPropOrFunc) : ModelBinding {	
		return new ModelBinding( this, propName, target, targetPropOrFunc )
	}
	
	/**
	* Unbind a specific property and target
	* 
	* @param	propName
	* @param	target
	*/
	public function unbind( propName:String, target:Object ) {
		if(target!=null && propName!=null) {		
			// remove bindings for the target object
			for(var n in _bindings) {
				if(_bindings[n].targetObject==target && _bindings[n].modelProp==propName) {
					removeBindingAtIndex(n);			
					return true;
				}
			}			
		} else {
			return false
		}
	}
	
	/**
	* Unbinds all bindings from this model
	* 
	* If a target object is passed in as an argument,
	* only bindings tied to that object will be removed
	* 
	* @param target
	*/
	public function unbindAll( target:Object ) {
		if(target!=null) {		
			// remove bindings for the target object
			for(var n in _bindings) {
				if(_bindings[n].targetObject==target) removeBindingAtIndex(n);			
			}			
		} else {
			Debug.warn('[Model '+_modelName+']  Removing All Bindings!!');
			var b:ModelBinding; 
			while(b = ModelBinding( _bindings.shift() )) {
				b.unbind();
			}
		}
	}
	
	
	/**
	* Binding registration interface (init)
	* 
	* <p>Used by the ModelBinding class to register bindings with
	* the master model.  This allows bindings to be unregistered
	* from the model.
	* 
	* @param	b
	*/
	public function registerBinding( b:ModelBinding ) {
		if(b==undefined || !b.bound) {
			Debug.error('[Model] Unable to register binding...');
			Debug.error(b);
		} else {
			//Debug.error('[Model] Registered binding...');
			//Debug.error(b);
			_bindings.push( b );
		}
	}
	
	/**
	* Binding registration interface (destroy)
	* 
	* <p>Used by the ModelBinding class to unregister itself if needed.
	* 
	* @param	b
	* @return
	*/
	public function unregisterBinding( b:ModelBinding ) : Boolean {
		for(var n in _bindings) {
			if(_bindings[n]==b) {
				removeBindingAtIndex(n);
				return true;
			}
		}
		return false;
	}
	
	/**
	* Helper - removes a binding at a given index
	* @param	n
	*/
	private function removeBindingAtIndex( n ) {
		_bindings[n].unbind();		
		delete _bindings[n];
	}
	
	/**
	 * Helper - trace/debug 
	 * @param	o
	 */
	private function dTrace(o) {
		if(!debug) return;
		if(typeof(o)=='object') {
			Debug.info( o );
		} else Debug.info( '[Model '+_modelName+'] '+o);
	}	
	
	
	
	
}
