/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import mx.events.EventDispatcher;

/**
 * FPSMeter is a simple Frames per second meter.  You can either turn it on in the interface or leave the connector on
 * stage, choose "true" in the PI for the showFPS option and it'll display a quick and dirty FPS meter right there
 * without having to use the interface
 *
 * @author John Grden :: John@blitzagency.com (co-author actually.  I onverted to class format from MX component).  I really can't
 * remember where I got the component or who wrote it.  So, feel free to let me know if you're the original author
 * and I'll be sure to add your credits here!
 */
class com.blitzagency.xray.FPSMeter
{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	/**
	 * @summary An event that is triggered when the fps setter has been updated.
	 *
	 * @return Object with one property: fps
	 */
	[Event("onFpsUpdate")]

	public var past:Number;
	public var now:Number;
	public var _fps:String;
	public var pass:Number;
	public var delta:Number;
	public var population:Array;
	public var display:TextField;
	public var _modus:Boolean;
	public var _runFPS:Boolean;
	public var populationSize:Number
	public var _pollInterval:Number;
	private var fpsSI:Number;

//=========================/[ GETTERS/SETTERS ]\======================>

	/**
     * @summary the current fps property
	 *
	 *
	 * @return String representing the Frames Per Second
	 */
	public function get fps():String
	{
		return _fps;
	}

	public function set fps(newValue:String):Void
	{
		_fps = newValue;

		// dispatch event
		this.dispatchEvent({type:"onFpsUpdate", fps:newValue});
	}

	public function get modus():Boolean
	{
		return _modus;
	}
	/**
     * @summary modus means to average the FPS or not.  If turned on, the FPS will be averaged
	 *
	 * @param newValue:Boolean
	 *
	 * @return nothing
	 */
	public function set modus(newValue:Boolean):Void
	{
		_modus = newValue;
	}

	public function get runFPS():Boolean
	{
		return _runFPS;
	}
	/**
     * @summary When runFPS is updated, and is set to "true", the interval poller is started
	 *
	 * @param newValue:Boolean Whether or not to poll for the FPS
	 *
	 * @return nothing
	 */
	public function set runFPS(newValue:Boolean):Void
	{
		_runFPS = newValue;
		//this.display._visible = newValue;
		clearInterval(this.fpsSI);
		if(newValue) this.fpsSI = setInterval(this, "update", pollInterval);
	}

	public function get pollInterval():Number
	{
		return _pollInterval;
	}
	/**
     * @summary The interval setting for the FPSMeter
	 *
	 * @param newValue:Number the interval setting
	 *
	 * @return nothing
	 */
	public function set pollInterval(newValue:Number):Void
	{
		_pollInterval = newValue;
		clearInterval(this.fpsSI);
		if(runFPS) this.fpsSI = setInterval(this, "update", pollInterval);
	}

//=========================\[ GETTERS/SETTERS ]/======================>

	public static var _instance:FPSMeter = null;

	public static function getInstance():FPSMeter
	{
		if(FPSMeter._instance == null)
		{
			FPSMeter._instance = new FPSMeter();
		}
		return FPSMeter._instance;
	}

	private function FPSMeter()
	{
		// initialize event dispatcher
		EventDispatcher.initialize(this);

		// init the meter
		init();
	}

	public function init():Void
	{
		this.past 			= 0;
		this.now 			= 0;
		this.fps 			= "";
		this.pass 			= 0;
		this.delta			= 0;
		this.populationSize = 10
		this.population 	= new Array( this.populationSize );

		this.runFPS = false;// set to false initially for admintool to turn on.
		this.modus = true;
		pollInterval = 25; // will set the pollInterval, but the FPS will not start since runFPS is false
	}

	public function update()
	{
		//trace("onenterframe fps");
		if(!this.runFPS) clearInterval(this.fpsSI);
		// Get ms. elapsed since movie start:
		this.now = getTimer();
		// Calc. ms. delta from previous pass;
		this.delta = this.now - this.past;

		if (this.modus)
		{
			// FPSMeter is in Average mode:

			// Store FPS in order the calc. average fps over populationSize lator on.
			this.population[ this.pass ] = this.delta;
			this.pass ++;

			// Do we have enough data to calc. an average? If so, calculate the average,
			// and trigger all listners.
			if ( this.pass >= (this.populationSize) )
			{
				var sum = 0;
				for (var measurement in this.population)
				{
					sum += this.population[ measurement ];
				}
				// Calulate FPS:
				var avg = int ((1000 * this.populationSize) / sum);

				this.fps = "["+avg+"fps]";

				// Reset pass counter:
				this.pass = 0;
			}
		}
		else
		{
			// FPSMeter is in Normal mode:

			// Calculate FPS:
			var val = int( 1000 / this.delta );
			this.fps = "["+val+"fps]";
		}

		// Store timer:
		this.past 	= this.now;
	}
}




