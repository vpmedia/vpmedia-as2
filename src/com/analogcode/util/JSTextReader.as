import mx.utils.Delegate;

import com.analogcode.util.EmbedObject;

import flash.external.ExternalInterface;
/**
 * @author astgtciv@analogcode.com
 * @version 1.1 (08/01/08)
 * 
 * The JSTextReader attempts to work around a bug that occurs with textinput in flash
 * when the swf is embedded with the wmode=transparent parameter. This bug occurs both in 
 * Firefox and Internet Explorer, albeit manifesting itself differently.
 * 
 * In Firefox, no matter what keyboard layout the user has, the swf receives keystrokes as if 
 * a US keyboard were used. In Internet Explorer, we get the "2 for 1" bug, where the true 4-byte unicode
 * characters received by the swf are split into 2 2-byte characters.  
 * 
 * JSTextReader wraps itself around a textfield. It sets up a javascript keystroke listener
 * corresponding to this swf object, and updates the textfield with the keystrokes from javascript
 * since javascript continues to receive correct char data.
 * 
 * JSTextReader changes the onChanged listener for the textfield. However, the original onChanged listener(s) 
 * that the user might have defined before creating JSTextReader and will define after the JSTextReader will 
 * work transparently. Do keep in mind however, that the reference to the onChanged handler will be changed and
 * should not be used in function comparisons.
 * 
 * When embedding the swf object into the html page, please make sure that 'allowScriptAccess' is set to 'always', 
 * and that the embed object has a unique id for that page. Setting an init variable '_embedObjectId' on the swf 
 * to the embed object id is optional (if not set, it should be obtained via the EmbedObject util). 
 * 
 * Usage: 
 * 
 * API:
 * 
 * Static methods:
 * 
 * JSTextReader.enableForAllTextFields(): Enables JSTextReader for all textfields.
 * JSTextReader.disableForAllTextFields(): Disables JSTextReader for all textfields.
 * 
 * Instance methods:
 * 
 * enableForTextField(tf:TextField): Enable this instance of JSTextReader for a TextField. If it was already enabled for another TextField, it will no longer work the old one.
 * disable(): Disable this instance of JSTextReader. 	
 * getTextField():TextField : Get the TextField for which this JSTextReader instance is currently enabled. If it is not enabled for any TextField, null is returned.
 *  
 * Construction: a TextField reference can be passed to the instance at construction time. 
 * var jsTextReader = new com.analogcode.util.JSTextReader(tf); // tf is a textfield reference
 * This is really shorthand for for:
 * var jsTextReader = new com.analogcode.util.JSTextReader(); 
 * jsTextReader.enableForTextField(tf); // tf is a textfield reference
 * 
 */
 
 class com.analogcode.util.JSTextReader {
	private static var jsPrefix:String = '';
	private static var jsInitialized:Boolean = false;
	private static var enabledForAllTF:Boolean = false;
	private static var instances:Array = []; 

	private var tf:TextField;
	private var lastText:String = '';
	private var curText:String = '';
	private var userOnChanged:Function;
	private var thisOnChanged:Function;
	
	/*
	 * Passing a TextField to the construct automatically enables 
	 * the new instance of JSTextReader for that TextField.
	 */
	function JSTextReader(tf:TextField) {
		if (initJS()) {
			instances.push(this);
			if (tf) {
				enableForTextField(tf);	
			}
		}
	}
	
	///////////////// API ////////////////////////////
	/*
	 * Enables JSTextReader for all textfields.
	 */
	public static function enableForAllTextFields() {
		initJS();
		if (!enabledForAllTF) {
			enabledForAllTF = true;
			Selection.addListener(JSTextReader);
		}	
	}
	
	/*
	 * Disables JSTextReader for all textfields. 
	 */
	public static function disableForAllTextFields() {
		if (enabledForAllTF) {
			enabledForAllTF = false;
			for (var i=0; i<instances.length; i++) {
				JSTextReader(instances[i]).disable();
			}
			instances = [];	
		}
		
		Selection.removeListener(JSTextReader);
	} 
	
	/*
	 * Enable this instance of JSTextReader for a TextField.
	 * If it was already enabled for another TextField, it will no longer work the old one.  
	 */
	public function enableForTextField(tf:TextField) {
		disable();
		// trace("Enabling JSTextReader instance for " + tf);
		this.tf = tf;
		lastText = tf.text;
		setPermanentOnChanged();
		tf.jsTextReaderEnabled = true;
	}

	/*
	 * Disable this instance of JSTextReader.
	 */	
	public function disable():Void {
		if (tf && userOnChanged) {
			tf.onChanged = userOnChanged;
		}
		
		tf.jsTextReaderEnabled = false;
		tf = null;
	}
	
	/*
	 * Get the TextField for which this JSTextReader instance is currently enabled. 
	 * If it is not enabled for any TextField, null is returned.
	 */
	public function getTextField():TextField {
		return tf;
	}	
	
	//////////////////////////////////////////////////////////////
	private static function onSetFocus(oldFocus:Object, newFocus:Object) {
		// trace("[onSetFocus] (newFocus instanceof TextField): " + (newFocus instanceof TextField));
		// if this is a new textfield that we haven't set up a JSTextReader instance for yet,
		// do so now
		if ((newFocus instanceof TextField) && (!newFocus.jsTextReaderEnabled)) {
			var jsTextReader:JSTextReader = new JSTextReader(TextField(newFocus));
		}
	}
	 
	private function setPermanentOnChanged() {
		// we have to save the ref to the Delegated version of this.onChanged, 
		// because we will be checking its reference later
		thisOnChanged = Delegate.create(this, onTextChanged);
		checkOnChanged();
		// Check every second if the user has switched onChanged, if so, change it to thisOnChanged
		setInterval(Delegate.create(this, checkOnChanged), 1000);	
	}
	
	private function checkOnChanged() {
		if ((!tf.onChanged) || (tf.onChanged != thisOnChanged)) {
			// The user has switched onChanged, switch it back
			userOnChanged = tf.onChanged;
			tf.onChanged = thisOnChanged;
		} 	
	}
	
	private function onTextChanged() {
		curText = tf.text;
		// trace("cur text: " + curText + toCharCodes(curText));
				
		var ignore:Boolean = false;
		
		var insert:String = '';
		// The problem with pasting on FF is that JS traps the "v" char when Ctrl-V
		// is pressed, and we end up showing that instead of the paste value.
		// The correct behavior is to just ignore the js input in case of paste 
		// (because the pasted text will come across correct anyway).
		if (!isPasting()) { 
			// the JS KeyboardInput might have accumulated some trash, but we want just the same number of chars
			// that made it into the text field, off the end of the js keyboard input stack
			insert = getKeyboardInputFromJS();
		}
		
		// Conceptually, the text in the tf is broken into 3 parts:
		// Prefix (before the newly inserted text), insert (the newly inserted text) and suffix (after the insert)
		// If the caret was at the end of text, the suffix is empty.
		var caretIndex:Number = Selection.getCaretIndex();
		var numCharsInserted:Number = curText.length - lastText.length;
		// trace("caretIndex: " + caretIndex + ", numCharsInserted: " + numCharsInserted );
		if ((!insert) && (numCharsInserted==0)) {
			// js/flash glitch that happens when typing really fast
			ignore = true; 
		} else if (numCharsInserted <= 0) {
			// Either this is backspace at work, or else some part of text was highlighted and then replaced
			// if the last char coming from JS is backspace, assume backspace (or delete)
			var lastJSChar:String = insert.substr(insert.length-1);
			if ((!insert) || (lastJSChar == "\u0008") || (lastJSChar == "\u002E")) {
				ignore = true; // nothing needs to be done, delete/backspace work by themselves :)
			} else {
				// Some part of text was highlighted and then replaced
				numCharsInserted = computeNumberOfDifferingChars();
			}
		} else if (isIE() && (numCharsInserted==1)) {
			// If we are in IE, and it appears that there is 1 char entered, 
			// we better computeNumberOfDifferingChars() - because this could be the scenario
			// where 1 char is highlighted and 1 keyboard key pressed to replace it, resulting in
			// 2 chars being entered (IE "1 Unicode char -> 2 chars" bug, see description below near computeNumberOfDifferingChars()), 
			// but since the difference is exactly 1 char... we better recompute to be sure.
			// Note this case covers just the (rather rare) scenario when 
			// 1. A true 4-byte unicode keyboard input is in effect (e.g., cyrillic)
			// 2. A single char is highlighted and then replaced by a keyboard stroke
			// However, if a european (not a true 4-byte unicode keyboard) input is in effect,
			// we are taking a processing hit since this function ends up executed every time a key
			// is pressed, and this function can be expensive for long strings.
			// If performance becomes a problem, we can enable another setting for to enable this feature 
			// (disabled by default).
			numCharsInserted = computeNumberOfDifferingChars();
		} 
		// trace("isIE: " + isIE() + ", numCharsInserted=" + numCharsInserted);
		
		if (!ignore) {
			insert = processKeyboardInput(insert, numCharsInserted);
			var prefix:String = curText.substr(0, caretIndex-numCharsInserted);
			var origTFInsert:String = curText.substr(caretIndex-numCharsInserted, numCharsInserted);
			var suffix:String = curText.substr(caretIndex);
	
			// if there is no keyboard input from js, assume it's a paste and keep the original tf insert 
			if (!insert) {
				insert = origTFInsert;
			}
			
			// trace("prefix: " + prefix + ", insert: " + insert + ", suffix: " + suffix + " " + toCharCodes(suffix) + ", origTFInsert: " + origTFInsert);
			tf.text = prefix+insert+suffix;
			// Fix for the IE double-char input bug, we adjust the cursor position if necessary
			if (insert.length != origTFInsert.length) {
				var cursorPos:Number = (prefix+insert).length;
				Selection.setSelection(cursorPos, cursorPos);
			}
		}
		
		lastText = tf.text;
		if (userOnChanged) {
			userOnChanged.apply(tf, arguments);	
		}
		// trace("new lastTextLength: " + this.lastTextLength);	
	}
	
	// Detects how many chars are different in curText from lastText.
	// The assumption is that curText differs from lastText by a single
	// substring in the middle. We need to do this
	// because of the IE version of the wmode=transparent bug, the "1 Unicode char -> 2 chars" bug.
	// This bug results in Unicode chars with values > 255 (2 bytes) being broken up into 2 chars
	// 2 bytes each and ending up that way in the textfield - as 2 chars (only for wmode=transparent).
	// To determine how many chars were entered, we traverse lastText and curText from 
	// front and then back, noting the first char that is different.
	// Note that this function could be expensive if the strings are long.
	// Also note that the number of differing chars here is computed based on curText, 
	// not of lastText.
	private function computeNumberOfDifferingChars() {
		var numCharsInserted;
		var leftInsertIndex:Number, rightInsertIndex:Number;
		for (var i:Number=0;i<curText.length;i++) {
			if (leftInsertIndex === undefined) {
				if (this.lastText.charAt(i) != curText.charAt(i)) {
					leftInsertIndex = i;
				}
			}
			
			if (rightInsertIndex === undefined) {
				if (this.lastText.charAt(lastText.length-i-1) != curText.charAt(curText.length-i-1)) {
					rightInsertIndex = curText.length-i-1;
				}
			}
			
			if ((leftInsertIndex !== undefined) && (rightInsertIndex !== undefined)) {
				break;
			}
		}
		// trace("leftInsertIndex: " + leftInsertIndex + ", " + "rightInsertIndex: " + rightInsertIndex);
		if ((leftInsertIndex !== undefined) && (rightInsertIndex !== undefined)) {
			numCharsInserted = (rightInsertIndex - leftInsertIndex) + 1;
		} else {
			numCharsInserted = 0;
		}
		
		return numCharsInserted; 	
	}	

	private static function executeJS(s:String, noFunc:Boolean) {
		var js:String = s;	
		if (!noFunc) {
			js = "function() {"+js+"}";
		}
		return ExternalInterface.call(js);
	}



	private function getKeyboardInputFromJS() {
		var keyboardInput:String = executeJS("return "+unq("popKeyboardInput")+"()");
		// keyboard input comes as "," separated list of unicodes
		var codes:Array = keyboardInput.split(',');
		keyboardInput = '';
		for (var i:Number=0; i<codes.length; i++) {
			keyboardInput += String.fromCharCode(Number(codes[i]));
		}
		
		// trace("keyboardInput from JS: " + keyboardInput +  " " + toCharCodes(keyboardInput));
		return keyboardInput;
	}

	private function processKeyboardInput(keyboardInput:String, numChars:Number) {
		// we remove a number of unrenderable chars (if garbage ends up being entered into the text field,
		// figure out the charcode(s) responsible and add them to this list). 
		var removable:Array = ["\u0008", // backspace
							   // "\u002E", // delete comes in as 46 (002E), but so does ".", so we can't remove it
							   "\u00C0" // some artifact that happens when keyboard layouts are being switched
							   ];
		for (var i:Number=0; i<removable.length; i++) {
			// trace("processing " + removable[i] + " (" + removable[i].charCodeAt(0) + ")");
			// TODO: This needs to be optimized.
			keyboardInput = keyboardInput.split(removable[i]).join("");
		}
		// we keep only the last numChars characters (however many were entered into the actual TF)
		// ideally, the best would be to leave just one char here... 
		// but it appears that at least in some situations flash is not fast enough and 
		// javascript starts to accrue several chars
		keyboardInput = keyboardInput.substr(keyboardInput.length-numChars);
		return keyboardInput;
	}

	private static function isJSAvailable():Boolean {
		return (ExternalInterface.available && executeJS("return true;"));	
	}
	
	/*
	 * Returns true if JS successfully initialized, for all successive calls to this
	 * method as well (even though JS is attempted to be initialized only once).
	 */
	private static function initJS():Boolean {
		if (!isJSAvailable()) {
			trace("[JSTextReader] Javascript not available, failed to set up JSTextReader.");
			trace("[JSTextReader] Please make sure that 'allowScriptAccess' is set to 'always' in the embed, and that the embed object has an id attribute unique for the page.");
			return false;	
		} else if (!EmbedObject.getId()) {
			trace("[JSTextReader] Cannot obtain EmbedObject id, failed to set up JSTextReader.");
			return false;	
		}
		
		// Javascript needs to be initialized only once
		if (jsInitialized) { 
			return true;
		}  
	
		// Note that unique func/var ids have to be used everywhere to allow for two or more concurrent
		// instances of the swf's runningJSTextReader to be used on the same page.
		
		executeJS(unq("onKey")+" = function (e) {" + 
					"if (!"+unq("keyboardInput")+") { "+unq("keyboardInput")+" = '';}" +
					"if ("+unq("popKeyboardInputTimeout")+") { clearTimeout("+unq("popKeyboardInputTimeout")+"); "+unq("popKeyboardInputTimeout")+"='';}" + 
					"var evtobj = window.event? event : e;" + 
					"var unicode = evtobj.charCode? evtobj.charCode : evtobj.keyCode;" +
					// "var actualkey = String.fromCharCode(unicode);" + 
					unq("keyboardInput")+" += ("+unq("keyboardInput")+"?',':'')+unicode;" + 
					// if flash didn't come for it soon, it's most likely garbage and we dont' want it.
					unq("popKeyboardInputTimeout")+" = setTimeout("+unq("popKeyboardInput") + ", 1000);" + 
					// debugging
		 			// "document.getElementById(\"ctext\").value = '!'+window.keyboardInput+'!';" + 
				"}");
		executeJS(unq("popKeyboardInput") + " = function() {" +
			   		  "var ret="+unq("keyboardInput")+";" +
					  unq("keyboardInput")+"='';" +
					  // debugging
					  // "document.getElementById(\"ctext\").value = '!'+window.keyboardInput+'!';" + 
					  "return ret;" +
				  "}");
		executeJS("var embedObject = document.getElementById('"+EmbedObject.getId()+"');" + 
				  "embedObject.onkeypress = "+unq("onKey")+";" 
				  );
				  
		jsInitialized = true;
		return true;		  
	}

	/*
	 * Debugging utility
	 */
	private function toCharCodes(s:String) {
		var r:String = "[";
		for (var i:Number=0;i<s.length;i++) {
			r+=s.charCodeAt(i) +" ";
		}
		return r + "]";
	}
	
	// TODO: This should support detecting paste on Mac's as well, but
	// I just can't find the keycode for Cmd (Cmd-V is the paste on Mac, right?)
	// Maybe this is not even possible to detect?
	private static function isPasting():Boolean {
		return (Key.isDown(Key.CONTROL) && Key.getCode()=='86');		
	}
	
	/*
	 * Are we running in IE?
	 */
	private static function isIE():Boolean {
		return (System.capabilities.playerType=='ActiveX');	
	}
	
	/*
	 * Returns the name of the js var/func with a unique prefix.
	 * TODO: Using window.[] variables might not work in a situation in which the html
	 * surrounding the flash is in a frame with its src loaded from a domain different from
	 * the domain of the top frame page. Perhaps this needs to be more versatile.
	 */
	private static function unq(s:String) {
		if (!jsPrefix) {
			jsPrefix = "_jstr_" + Math.floor(Math.random()*10000) + "_";	
		}
		return "window." + jsPrefix + s;	
	}

}