/**
* KeyLauncher Class v1.5
* Author  : Mika Palmu
* Licence : Use freely, giving credit when you can.
* Website : http://www.meychi.com/
*/
class com.vpmedia.input.KeyLauncher
{
	/**
	* Variables
	*/
	private var active:Boolean;
	private var keyword:String;
	private var callbacks:Array;
	private var container:String;
	private var listener:Object;
	public var onWord:Function;
	public var onChar:Function;
	/**
	* Constructor
	*/
	public function KeyLauncher ()
	{
		var reference = this;
		this.active = false;
		this.container = new String ("");
		this.callbacks = new Array ();
		this.listener = new Object ();
		this.listener.onKeyUp = function ()
		{
			var char:String = String.fromCharCode (Key.getAscii ());
			reference.checkCallbacks (char);
			if (reference.active)
			{
				reference.checkForWord (char);
			}
		};
		Key.addListener (listener);
	}
	/**
	* Sets the keyword and activates the keyword listening.
	*/
	public function setKeyword (keyword:String):Void
	{
		this.keyword = keyword;
		this.active = true;
	}
	/**
	* Adds a new callback object to the "callbacks" array.
	*/
	public function addCallback (char:String, callback:Function):Void
	{
		this.callbacks.push ({char:char, callback:callback});
	}
	/**
	* Removes the specified callback.
	*/
	public function removeCallback (char:String):Void
	{
		for (var i = 0; i < this.callbacks.length; i++)
		{
			if (this.callbacks[i].char == char)
			{
				for (var j = i; j < this.callbacks.length - 1; j++)
				{
					this.callbacks[j] = this.callbacks[j + 1];
				}
				this.callbacks.pop ();
			}
		}
	}
	/**
	* Checks that if the user has typed the keyword.
	*/
	private function checkForWord (char:String):Void
	{
		this.container += char;
		if (this.container == this.keyword)
		{
			this.container = new String ("");
			this.onWord ();
		}
		else if (this.container != this.keyword.substr (0, this.container.length))
		{
			this.container = new String ("");
		}
	}
	/**
	* Calls the specified callback, if the object exists.
	*/
	private function checkCallbacks (char:String):Void
	{
		for (var i = 0; i < this.callbacks.length; i++)
		{
			if (this.callbacks[i].char == char)
			{
				this.callbacks[i].callback ();
				this.onChar (char);
			}
		}
	}
}
