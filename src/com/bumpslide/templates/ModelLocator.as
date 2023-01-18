import com.bumpslide.data.*;
import com.bumpslide.util.*;

/**
* Template for Model Locator
* 
* All application-wide data should be stored here.
* 
* Data that we need to be able to monitor and/or bind to can be 
* stored in an instance of the 'Model' class which is basically 
* an observable hash map.  
* 
* Note: Rename 'app' to something unique to your project.
* 
* Copyright (c) 2006, David Knape and contributing authors
* Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
* 
* @author David Knape
*/
class app.ModelLocator
{		
	// This is where we maintain our application state
	var state:Model;
	
	// other data can be stored here as well
	// for instance, large arrays and recordsets that we don't want to 
	// track in our observable model
	
	var searchResults:mx.remoting.RecordSet;
	var menuOptions:Array;
	
	
	// example configuration variable (overriden by flashvars in constructor)
	var urlRoot:String = "http://localhost/myapp/";
	
	// singleton instance...
	static private var instance:ModelLocator;
		
	
	/**
	* Private constructor for Singleton
	*/
	private function ModelLocator() 
	{		
		init();
		
		// override configuration variables if found in flashvars
		if(_root.urlRoot!=undefined) urlRoot = _root.urlRoot;
	}
		
	/**
	* singleton access method
	*/
	public static function getInstance() : ModelLocator 
	{
		if (instance == null) instance = new ModelLocator();
		return instance;
	}	

	
	/**
	* ModelLocator initialization code
	*/
	private function init() : Void 
	{		
		// First, we create observable model to manage application state changes
		
		// we define a new model by creating an anonymous object
		// that represents our state vars and their default values
		// we then pass it in to our Model constructor which will then 
		// give us a hash map with auto-magically created getters and setters
		// for each state var to which we can bind our view clips
		
		var stateVars = {
			section: 1,
			subsection: 0, 
			selectedItems: [2,3],
			tooltipText: ""
		};
		
		state = new Model( stateVars );		
		
		// We will listen for change requests here
		state.addEventListener( Model.CHANGE_REQUEST_EVENT, Delegate.create( this, onStateChangeRequested)  );
			
		// Now that we have application state in a bindable model,
		// we can use the HistoryTracker to track specific state changes,
		// thus enabling the back button in our browser
		
		// in this case, we want changes to both section and selectedItems
		// to be register and browser history events. Note, we are ignoring 
		// subsection and tooltip text for the sake of this example
		
		history = new HistoryTracker();
		history.init( state, ['section', 'selectedItems'] );
	}
	
	
	/**
	* Called whenever a state change is requested
	* 
	* we can intercept change requests here if necessary, or simply
	* monitor state changes for the sake of debugging.
	* 
	* @param	e
	*/
	private function onStateChangeRequested( e:ModelValueChangeRequestEvent ) 
	{
		Debug.trace("[ModelLocator] State Change Request: "+e.key+" => "+e.newValue);
	}
	
	
}
