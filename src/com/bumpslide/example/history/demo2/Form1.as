import com.bumpslide.example.history.demo2.*;
import com.bumpslide.example.history.*;
import com.bumpslide.util.*;

class com.bumpslide.example.history.demo2.Form1 extends BaseClip
{
	var numbers_lb : mx.controls.List;

	
	function Form1() 
	{
		_visible = false;
	}
	
	// listen to listbox change event and bind to state changes
	function onLoad() {
		super.onLoad();
		numbers_lb.addEventListener( 'change', Delegate.create(this, onListBoxChange));		
		state.bind( 'selectedItems', this );
		_visible = true;
	}
	
	// when state changes, update listbox
	function set selectedItems ( newVals ) {
		numbers_lb.selectedIndices = newVals;		
	}
	
	// when listbox changes, update state
	function onListBoxChange() 
	{	
		// get list of selected item indices
		var a:Array = numbers_lb.selectedIndices;
		
		// if no items were selected, make a an empty array
		if (a==undefined) {
			a = [];
		} else {
			// sort index list
			a.sort();
		}
		
		// update state
		state.selectedItems = a;
	}
}
