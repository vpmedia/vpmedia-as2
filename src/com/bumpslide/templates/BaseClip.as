import com.bumpslide.data.Model;
import app.*;

/**
* Template for Application Base Clip
* 
* Main view components (movie clips) can extend this class to automatically
* gain all the bumpslide BaseClip shortcuts as well as application-specific 
* model, service, and state hooks as defined here here.
*  
* Note: Rename 'app' to something unique to your project.
* 
* Copyright (c) 2006, David Knape and contributing authors
* Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
* 
* @author David Knape
*/
class app.BaseClip extends com.bumpslide.core.BaseClip {
		
	// our service proxy (if needed)
	//private var service:ServiceProxy; 
	
	// our data repository
	private var model:ModelLocator;
	
	// shortcut to application state (inside ModelLocator)
	private var state:Model;
		
	/**
	* Use constructor 
	*/
	function BaseClip ()
	{		
		super();		
		
		//service    = ServiceProxy.getInstance();
		model      = ModelLocator.getInstance();
		state  	   = model.state;
	}
		
	// on unload, release all state bindings
	function onUnload() {
		super.onUnload();
		state.unbindAll( this );
	}
}