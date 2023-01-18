import com.bumpslide.data.Model;
import com.bumpslide.example.history.demo2.ModelLocator;
import com.bumpslide.util.*;

/**
* Application-wide base clip for history demo 2
*/
class com.bumpslide.example.history.demo2.BaseClip extends MovieClip
{
	// reference to ModelLocator
	var model:ModelLocator;
	
	// shortcut too application state model
	var state:Model;
	
	// reference to stage (resize event proxy)
	var stage:StageProxy;
		
	function BaseClip()
	{
		model = ModelLocator.getInstance();
		state = model.state;
		stage = StageProxy.getInstance();
	}
}
