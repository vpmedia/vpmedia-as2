class com.vpmedia.crypt.PasswordGenerator {
	private var length:Number;
	private var password:String;
	private var template:String;
	private var numbersIncluded:Boolean;
	private var lowercaseIncluded:Boolean;
	private var uppercaseIncluded:Boolean;
	private var othersIncluded:Boolean;
	
	public static var MIN_PASSWORD_LENGTH = 3;

	function PasswordGenerator() {
		this.length = 8;
		this.password = "";
		this.template = "";
		this.numbersIncluded = true;
		this.lowercaseIncluded = true;
		this.uppercaseIncluded = true;
		this.othersIncluded = false;
	}
	
	// returns true if at least one generation flag is set
	private function flagsOK():Boolean {
		return this.numbersIncluded || this.lowercaseIncluded || this.uppercaseIncluded || this.othersIncluded;	
	}
	
	private static function randomNumber():String {
		return String.fromCharCode(48 + Math.floor((Math.random() * 10)));	
	}
	private static function randomLowercase():String {
		return String.fromCharCode(97 + Math.floor((Math.random() * 26)));	
	}
	private static function randomUppercase():String {
		return String.fromCharCode(65 + Math.floor((Math.random() * 26)));	
	}
	private static function randomOther():String {
		return String.fromCharCode(33 + Math.floor((Math.random() * 15)));		
	}
	
	public function generatePassword():Void {
		this.password = "";
			
		// a template being defined overrides all flags
		if (template.length > 0) {
			// assign the password length the same
			// value as the template length
			this.length = template.length;
			for (var i:Number = 0; i < this.length; i++) {
				switch (template.charAt(i)) 
				{
					case 'a' :
						this.password += randomLowercase();
						break;

					case 'A' :
						this.password += randomUppercase();
						break;

					case 'n' :
					case 'N' :
						this.password += randomNumber();
						break;

					case 'o' :
					case 'O' :
						this.password += randomOther();
						break;
					
					// there is no default case here because
					// our setter/constructor ensures data
					// integrity
				}
			}
		} 
		else // create the password based on the flags
		{
			var randChar:Array = new Array();
			if (this.numbersIncluded) {
				randChar.push(PasswordGenerator.randomNumber);
			}
			if (this.lowercaseIncluded) {
				randChar.push(PasswordGenerator.randomLowercase);
			}
			if (this.uppercaseIncluded) {
				randChar.push(PasswordGenerator.randomUppercase);
			}
			if (this.othersIncluded) {
				randChar.push(PasswordGenerator.randomOther);
			}
			
			for (var i:Number = 0; i < this.length; i++) {
				this.password += randChar[Math.floor(Math.random() * randChar.length)]();
			}
		}
	}
	
	public function get NumbersIncluded():Boolean {
		return this.numbersIncluded;
	}
	public function set NumbersIncluded(value:Boolean):Void {
		this.numbersIncluded = value;
		// keep data in a consistent state -- at least
		// one flag must be set to generate a password
		// without a template
		if (value == false && !this.flagsOK()) {
			this.numbersIncluded = true;
		}
	}
	
	public function get LowercaseIncluded():Boolean {
		return this.lowercaseIncluded;
	}
	public function set LowercaseIncluded(value:Boolean):Void {
		this.lowercaseIncluded = value;
		// keep data in a consistent state -- at least
		// one flag must be set to generate a password
		// without a template
		if (value == false && !this.flagsOK()) {
			this.lowercaseIncluded = true;
		}
	}
	
	public function get UppercaseIncluded():Boolean {
		return this.uppercaseIncluded;
	}
	public function set UppercaseIncluded(value:Boolean):Void {
		this.uppercaseIncluded = value;
		// keep data in a consistent state -- at least
		// one flag must be set to generate a password
		// without a template
		if (value == false && !this.flagsOK()) {
			this.uppercaseIncluded = true;
		}
	}
	
	public function get OthersIncluded():Boolean {
		return this.othersIncluded;
	}
	public function set OthersIncluded(value:Boolean):Void {
		this.othersIncluded = value;
		// keep data in a consistent state -- at least
		// one flag must be set to generate a password
		// without a template
		if (value == false && !this.flagsOK()) {
			this.othersIncluded = true;
		}
	}
	
	public function get Length():Number {
		return this.length;
	}
	
	public function set Length(value:Number):Void {
		this.length = (value < MIN_PASSWORD_LENGTH) ? MIN_PASSWORD_LENGTH : value;
	}
	
	public function get Password():String {
		return this.password;
	}
	
	public function get Template():String {
		return this.template;
	}
	
	public function set Template(value:String):Void {
		var throwError:Boolean = false;
		var errorPosition:Number = 0;
		
		// clear the template
		this.template = "";
		
		// make sure the template contains only legal characters
		for (var i:Number = 0; i < value.length; i++) {
			switch (value.charAt(i))  {
				case 'a' :
				case 'A' :
				case 'n' :
				case 'N' :
				case 'o' :
				case 'O' :
					template += value.charAt(i);
					break;
			
				default :
					if (!throwError) {
						throwError = true;
						// keep track of where the error occured
						errorPosition = i;
					}
					break;
			}
		}
		
		if (throwError) {
			throw new Error("Password template contains an invalid character at position " + errorPosition + " - " + value.charAt(errorPosition));
		}
	}
}
