import com.bumpslide.example.history.demo2.BaseClip;
import com.bumpslide.util.*;

class com.bumpslide.example.history.demo2.Form2 extends BaseClip
{
	var NUM_CHECKBOXES : Number = 5;
	
	function Form2() {
		_visible = false;
	}
	
	// listen to checkbox events and bind to state
	function onLoad() 
	{				
		super.onLoad();
		var i=NUM_CHECKBOXES;		
		while(i--) cb(i).addEventListener( 'click', this);
		
		state.bind('selectedItems', this );
		
		_visible = true;		
	}
		
	// when a checkbox is clicked, update our model
	function click() 
	{		
		state.selectedItems = getSelectedCheckboxIds();
	}
	
	// when selected items change, 
	// select the checkboxes that correspond to those values
	function set selectedItems ( newVals ) {	
		// deselect all and then just select the ones that need to be selected
		deselectAll()
		var i=newVals.length;				
		while(i--) cb(newVals[i]).selected = true;	
	}	
		
	// helper: returns reference to checkbox for a given id
	function cb(n:Number) {
		return this['cb'+n];
	}
	
	// helper: returns array of ids corresponding to the 
	// selected checkboxes in this form
	function getSelectedCheckboxIds() 
	{		
		var selectedIds = [];
		var i=NUM_CHECKBOXES;
		while(i--) if(cb(i).selected) selectedIds.push(i);
		selectedIds.sort();	
		return selectedIds;
	}
	
	// helper: deselect all checkboxes
	function deselectAll() {
		var i=NUM_CHECKBOXES;
		while(i--) cb(i).selected = false;
	}
	
	

}
