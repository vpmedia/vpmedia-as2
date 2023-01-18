// package com.darronschall;   
// maybe the next release will have package support?  We have to
// import the PasswordGenerator since we can't declare a package..
import com.vpmedia.crypt.PasswordGenerator;

// import all of the UI Objects we'll need - all of these needs to
// be in the library of the .fla file in order for them to
// be created at run-time.
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.Label;
import mx.controls.NumericStepper; // <-- yay!
import mx.controls.TextInput;

class com.vpmedia.crypt.PasswordGeneratorUI {
	// the movie clip to attach all of the UI elements to
	private var target_mc:MovieClip;
	
	// Declare all of the UI interface elements
	private var password_label:Label;
	private var include_label:Label;
	private var template_label:Label;
	private var tip_label:Label;
	private var length_label:Label;
	private var lowercase_ch:CheckBox;
	private var uppercase_ch:CheckBox;
	private var numbers_ch:CheckBox;
	private var others_ch:CheckBox;
	private var password_txt:TextInput;
	private var template_txt:TextInput;
	private var length_stepper:NumericStepper;
	private var generate_btn:Button;
	private var copy_btn:Button;
	private var clear_btn:Button;
	
	// Are we using flags or a template?
	private var topEnabled:Boolean; // true = flags, false = template

	// we need a password generator to create the passwords
	private var passGen:PasswordGenerator;
	
	// ------------------------------------
	
	private function initializeComponents() {
		// Thank you MM for easy depth management.  :-)
		
		// Create all of the UI elements in the target movieclip
		password_label = target_mc.createClassObject(Label, "password_label", target_mc.getNextHighestDepth());
		include_label = target_mc.createClassObject(Label, "include_label", target_mc.getNextHighestDepth());
		template_label = target_mc.createClassObject(Label, "template_label", target_mc.getNextHighestDepth());
		tip_label = target_mc.createClassObject(Label, "tip_label", target_mc.getNextHighestDepth());
		length_label = target_mc.createClassObject(Label, "length_label", target_mc.getNextHighestDepth());
		lowercase_ch = target_mc.createClassObject(CheckBox, "lowercase_ch", target_mc.getNextHighestDepth());
		uppercase_ch = target_mc.createClassObject(CheckBox, "uppercase_ch", target_mc.getNextHighestDepth());
		numbers_ch = target_mc.createClassObject(CheckBox, "numbers_ch", target_mc.getNextHighestDepth());
		others_ch = target_mc.createClassObject(CheckBox, "others_ch", target_mc.getNextHighestDepth());
		password_txt = target_mc.createClassObject(TextInput, "password_txt", target_mc.getNextHighestDepth());
		template_txt = target_mc.createClassObject(TextInput, "template_txt", target_mc.getNextHighestDepth());
		length_stepper = target_mc.createClassObject(NumericStepper, "length_stepper", target_mc.getNextHighestDepth());
		generate_btn = target_mc.createClassObject(Button, "generate_btn", target_mc.getNextHighestDepth());
		copy_btn = target_mc.createClassObject(Button, "copy_btn", target_mc.getNextHighestDepth());
		clear_btn = target_mc.createClassObject(Button, "clear_btn", target_mc.getNextHighestDepth());
		
		password_label.move(8, 8);
		password_label.text = "Password:";
		
		include_label.move(8, 88);
		include_label.text = "Include:";
		
		template_label.move(8, 160);
		template_label.autoSize = "left";
		template_label.text = "Password Template (\'a\' = lowercase, \'A\' = uppercase, \n\'n\' or \'N\' = number, \'o\' or \'O\' = other):";
		
		tip_label.move(8, 232);
		tip_label.autoSize = "left";
		tip_label.text = "Tip: Clear the password template to use the settings above.";
		
		length_label.move(8, 56);
		length_label.text = "Length:";
		
		lowercase_ch.move(8, 112);
		lowercase_ch.tabIndex = 5;
		lowercase_ch.label = "Lowercase";
		// Because this class has a function "click" defined, we
		// can pass in "this" as a listener for click events..
		lowercase_ch.addEventListener("click", this);
		
		uppercase_ch.move(96, 112);
		uppercase_ch.tabIndex = 6;
		uppercase_ch.label = "Uppercase";
		uppercase_ch.addEventListener("click", this);
		
		numbers_ch.move(184, 112);
		numbers_ch.tabIndex = 7;
		numbers_ch.label = "Numbers";
		numbers_ch.addEventListener("click", this);
		
		others_ch.move(256, 112);
		others_ch.tabIndex = 8;
		others_ch.label = "Others";
		others_ch.addEventListener("click", this);

		password_txt.move(16, 24);
		password_txt.tabIndex = 1;
		password_txt.text = "";
		password_txt.editable = false;

		template_txt.move(8,200);
		template_txt.tabIndex = 9;
		template_txt.setSize(184, 20);
		template_txt.text = "";
		// restrict input.. rock and roll!
		template_txt.restrict = "aAnNoO";
		// Because this class has a function "change" defined, we
		// can pass in "this" as a listener for change events..
		template_txt.addEventListener("change", this);
		
		length_stepper.move(56, 56);
		length_stepper.tabIndex = 3;
		length_stepper.setSize(50, 20);
		length_stepper.addEventListener("change", this);
		
		generate_btn.move(224, 24);
		generate_btn.tabIndex = 2;
		generate_btn.label = "Generate";
		generate_btn.addEventListener("click", this);
		
		copy_btn.move(224, 56);
		copy_btn.tabIndex = 4;
		copy_btn.label = "Copy";
		copy_btn.addEventListener("click", this);
		
		clear_btn.move(208, 200);
		clear_btn.tabIndex = 10;
		clear_btn.label = "Clear Template";
		clear_btn.addEventListener("click", this);
	}
	
	private function enableAccessibility() {
		mx.accessibility.ButtonAccImpl.enableAccessibility();
		//mx.accessibility.TextInputAccImpl.enableAccessibility();
		//mx.accessibility.NumericStepperAccImpl.enableAccessibility();
		mx.accessibility.CheckBoxAccImpl.enableAccessibility();
	}
	
	// -----------[ MAIN ]---------------------
	public function PasswordGeneratorUI(target_mc:MovieClip) {
		this.target_mc = target_mc;
		
		enableAccessibility();
		initializeComponents();
		
		
		passGen = new PasswordGenerator();
		topEnabled = true;

		// initialize UI to be default password values

		length_stepper.minimum = PasswordGenerator.MIN_PASSWORD_LENGTH;
		length_stepper.maximum = 100;
		length_stepper.value = passGen.Length;
			
		lowercase_ch.selected = passGen.LowercaseIncluded;
		uppercase_ch.selected = passGen.UppercaseIncluded;
		numbers_ch.selected = passGen.NumbersIncluded;
		others_ch.selected = passGen.OthersIncluded;
		
		password_txt.text = passGen.Password;
		template_txt.text = passGen.Template;
		
		// make sure the change event fires for the text
		change({target:template_txt});
	}
	
	private function click(eventObj) {
		switch (eventObj.target) {
			case lowercase_ch: 
			case uppercase_ch:
			case numbers_ch:
			case others_ch:
				var which:String = eventObj.target._name.split("_")[0];
				
				// make the first letter uppercase so that we access
				// passGen with the public properties, isntead of
				// the private variables.  This is somewhat of a bug in
				// the private keyword since it's compile-time only checking, 
				// as "private" variables can be accessed outside of 
				// the class.. We don't want to access the private
				// variables because the public properties
				// define set functions that ensures data integrity.
				which = which.substr(0,1).toUpperCase() + which.substr(1,which.length);
				
				passGen[which+"Included"] = !passGen[which+"Included"];
				eventObj.target.selected = passGen[which+"Included"];
				
				//generate_btn.onRelease();
				// call generate_btn with the clickListener instead
				// so that the generate_btn doesn't steal focus
				click({target:generate_btn});
				break;
			
			case generate_btn:
				// generate a new password
				passGen.generatePassword();
				this.password_txt.text = passGen.Password;
				break;
				
			case clear_btn:
				// clear the template and generate a new password
				this.template_txt.text = "";
				change({target:template_txt});
				break;
				
			case copy_btn:
				// copy the password text to the clipboard
				System.setClipboard(this.password_txt.text);
				break;
				
		}
	}
	
	private function change(eventObj) {
		switch (eventObj.target) {
			case length_stepper:
				passGen.Length = length_stepper.value;
				break;
				
			case template_txt:
				passGen.Template = template_txt.text;
				
				if (template_txt.text.length > 0) {
					setUseFlags(false);
				} else {
					setUseFlags(true);
					passGen.Length = this.length_stepper.value;
				}
				break;
		}
		
		//generate_btn.onRelease();
		// call generate_btn with the clickListener instead
		// so that the generate_btn doesn't steal focus
		click({target:generate_btn});
	}
	
	private function setUseFlags(useFlags:Boolean):Void {
		// enable/disable the UI components
		lowercase_ch.enabled = useFlags;
		uppercase_ch.enabled = useFlags;
		numbers_ch.enabled = useFlags;
		others_ch.enabled = useFlags;
		length_stepper.enabled = useFlags;
		
		// clear button enabled is the opposite of the flags enabled
		clear_btn.enabled = !useFlags;
		
		// update our local boolean.  this variable isn't 100% necessary
		// as we can used the "enabled" property of one of the ui
		// elements...
		topEnabled = useFlags;
	}
}