import com.bumpslide.example.history.demo2.BaseClip;
import com.bumpslide.util.Debug;
import com.bumpslide.example.history.demo2.ModelLocator;

class com.bumpslide.example.history.demo2.StatefulButton extends BaseClip
{
	public var label_txt:TextField;
	private var mySectionNum:Number;
	
	function StatefulButton() 
	{	
		super();		
		stop();
		
		// pull section num from instance name
		mySectionNum = _name.split('_')[1];
		
		// setup label
		label_txt.autoSize = true;
		label_txt.text = "Section "+mySectionNum;
		label_txt._x = Math.round((_width-label_txt._width)/2);	
		
		// bind to state.section
		state.bind( 'section', this );
	}
	
	// button behavior
	private function onRelease() {
		state.section = mySectionNum;	
	}
	
	// on state.section changed (binding)
	function set section ( n ) 
	{	
		onEnterFrame = updateSelectedState;
	}
	
	function updateSelectedState() 
	{		
		delete onEnterFrame;		
		if(state.section == mySectionNum) {
			enabled = false;
			gotoAndStop( 'selected' );
		} else {
			enabled = true;
			gotoAndStop( '_up' );
		}
	}
		
	
}
