/**
* MouseRecorder Class v1.0
* Author  : Mika Palmu
* Licence : Use freely, giving credit when you can.
* Website : http://www.meychi.com/
*/
class com.vpmedia.input.MouseRecorder
{
	/**
	* Variables
	*/
	private var down:Boolean;
	private var delay:Number;
	private var counter:Number;
	private var listener:Object;
	private var interval:Number;
	private var coordinates:Array;
	public var onComplete:Function;
	public var onRecord:Function;
	public var onDown:Function;
	/**
	* Constructor
	*/
	public function MouseRecorder ()
	{
		this.counter = 0;
		this.down = false;
		var reference = this;
		this.coordinates = new Array ();
		this.listener = new Object ();
		this.listener.onMouseDown = function ()
		{
			reference.down = true;
		};
		this.listener.onMouseUp = function ()
		{
			reference.down = false;
		};
		Mouse.addListener (this.listener);
		this.delay = 100;
	}
	/**
	* Gets the amount of saves made.
	*/
	public function getRecorded ():Number
	{
		return this.coordinates.length;
	}
	/**
	* Sets the delay in milliseconds.
	*/
	public function setDelay (delay:Number):Void
	{
		this.delay = delay;
	}
	/**
	* Gets the delay in milliseconds.
	*/
	public function getDelay ():Number
	{
		return this.delay;
	}
	/**
	* Starts to record the x and y coodinates of the mouse.
	*/
	public function record ()
	{
		this.interval = setInterval (function (reference:MouseRecorder)
		{
			reference.coordinates.push ({x:_root._xmouse, y:_root._ymouse, down:reference.down});
			reference.onRecord ({x:_root._xmouse, y:_root._ymouse, down:reference.down});
		}, this.delay, this);
	}
	/**
	* Plays the recorded moves of the mouse with a cursor movieclip.
	*/
	public function play ()
	{
		this.stop ();
		_root.attachMovie ("cursor", "cursor", 1);
		this.interval = setInterval (function (reference:MouseRecorder, counter:Number)
		{
			var counter:Number = reference.counter++;
			if (reference.coordinates[counter] != undefined)
			{
				if (reference.coordinates[counter].down)
				{
					reference.onDown ();
				}
				_root.cursor._x = reference.coordinates[counter].x;
				_root.cursor._y = reference.coordinates[counter].y;
			}
			else
			{
				reference.stop ();
				reference.onComplete ();
			}
		}, this.delay, this, counter);
	}
	/**
	* Stops the recording of the x and y coodinates of the mouse.
	*/
	public function stop ()
	{
		clearInterval (this.interval);
		_root.cursor.removeMovieClip ();
		this.counter = 0;
	}
	/**
	* Clears all recorded mouse coordinates.
	*/
	public function clear ()
	{
		while (this.coordinates.length > 0)
		{
			this.coordinates.pop ();
		}
		this.counter = 0;
	}
	/**
	* Moves the playhead to the specified frame.
	*/
	public function move (frame:Number)
	{
		this.counter = frame;
	}
}
