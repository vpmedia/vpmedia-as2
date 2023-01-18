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

 
import com.bumpslide.events.Event;
import com.bumpslide.util.Debug;
import org.asapframework.management.movie.*;
import org.asapframework.ui.input.InputEvent;

/**
 *  This is an asapframework HintedInputField with a select state.
 * 
 *  Automatic addition of nearest controller as a listener has been removed.
 *  See source for details.
 * 
 *  @author David Knape
 */


dynamic class com.bumpslide.ui.InputField extends org.asapframework.ui.input.HintedInputField
{
	
	// duplicating InputField event here
	public static var ON_CHANGED:String = "onInputFieldChanged";
	
	// added enter key event
	public static var ON_ENTER_KEY:String = "onInputFieldEnterKeyPressed";
	
	/*
	var mController : LocalController;
	
	function onLoad() {
		super.onLoad();	
		mController = MovieManager.getInstance().getNearestLocalController(this);		
		if (_autoAddChangeListener && mController != null) {
			addEventListener(InputEvent.ON_CHANGED, mController);
		}
	}
	*/
	
	function InputField() {
		super();
		stop();
	}
	
	function onLoad() {
		super.onLoad();
		if(mInput.text!="") hint = mInput.text;
	}
	
	function set value( input:String ) {
		
		if (input=="" || input==mTrimmedHint) 
		{
			// nothing or hint itself typed, show hint
			if (mHint != null) {
				hint = mHint;
			} else {
				hint = "";
			}
		} else {
		
			text = input; 
			
		}
	
	}
	
	function get value():String {
		return getValue().toString();
	}
	
	function onUnload() 
	{
		super.onUnload();		
		//if(mController!=null) removeEventListener( InputEvent.ON_CHANGED, mController );
	}
	
	public function onChangeTextFocus ( inFocus:Boolean ) : Void 
	{	
		super.onChangeTextFocus(inFocus);
		
		if(mHasFocus) {
			_selected(); 
			Key.addListener( this );
		} else { 
			_off();
			Key.removeListener( this );
		}
	}
	
	function onKeyDown() 
	{
		if(Key.isDown(Key.ENTER)) {
			onEnterKeyPressed();
			dispatchEvent( new Event(ON_ENTER_KEY, this ) );
			Selection.setFocus(null);
		}
	}
	
	function _selected() {
		gotoAndStop('selected');
	}
	
	function _off() {
		gotoAndStop('off');
	}
	
	// for future use
	function onEnterKeyPressed() {
		Debug.trace('Enter pressed');
	}
	
}
