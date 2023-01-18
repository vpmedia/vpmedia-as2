import com.bumpslide.example.history.demo2.BaseClip;
import com.bumpslide.util.*;

class com.bumpslide.example.history.demo2.Form3 extends BaseClip
{
	var array_txt : mx.controls.TextInput;

	// listen to textInput events and bind to state
	function onLoad() 
	{		
		array_txt.addEventListener( 'focusOut', Delegate.create(this, onTextChange));
		array_txt.addEventListener( 'enter', Delegate.create(this, onTextChange));
		
		state.bind('selectedItems', this);
	}
	
	// when selected items change, 
	// update our text box with the string representation of that array
	function set selectedItems ( items ) 
	{		
		array_txt.text = items.toString();		
	}
	
	// when the textbox is changed, 
	// update our model
	function onTextChange() 
	{
		var ids:Array = array_txt.text.split(',');
		for(var n in ids) ids[n] = parseInt( ids[n] );
		ids.sort();		
		state.selectedItems = ids;
	}
}
