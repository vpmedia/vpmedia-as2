import com.bumpslide.data.HistoryTracker;
import com.bumpslide.data.Model;
import com.bumpslide.util.*;

/**
* Run-time application data storage
* 
* All application-wide data should be stored here.
* 
* Data that we need to be able to monitor and/or bind to can be 
* stored in an instance of the 'Model' class which is basically 
* an observable hash map.
* 
* In this example, we are storing application state in a Model 
* called state.
* 
* @author David Knape
*/
class com.bumpslide.example.history.demo2.ModelLocator
{		
	// Bindable Application State vars
	public var state : Model;
	
	// Browser history tracker
	public var history : HistoryTracker;
		
	// singleton instance...
	static private var instance:ModelLocator;
	
	/**
	* singleton access method
	*/
	public static function getInstance() : ModelLocator {
		if (instance == null) instance = new ModelLocator();
		return instance;
	}	
	
	/**
	* Private constructor for Singleton
	*/
	private function ModelLocator() {
		init();
	}
	
	
	/**
	* ModelLocator initialization code
	*/
	private function init() : Void {
		
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
		
		// Now that we have application state in a bindable model,
		// we can use the HistoryTracker to track specific state changes,
		// thus enabling the back button in our browser
		
		// in this case, we want changes to both section and selectedItems
		// to be register and browser history events. Note, we are ignoring 
		// subsection and tooltip text for the sake of this example
		
		history = new HistoryTracker();
		history.init( state, ['section', 'selectedItems'] );
	}
	
	
		
	
		
}
