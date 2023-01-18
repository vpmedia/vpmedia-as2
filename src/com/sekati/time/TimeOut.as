/** * com.sekati.time.TimeOut * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */ /** * TimeOut * {@code Usage: * 	var t:TimeOut = new TimeOut(testFn, 500, [arg0, arg1, foo]); * } */class com.sekati.time.TimeOut {	private var _this:TimeOut;	private var _INTERVAL:Number;	/**	 * Constructor	 * @param f (Function)	 * @param ms (Number)	 * @param args (Array)	 */	public function TimeOut(f:Function, ms:Number, args:Array) {		_this = this;		var fn:Function = function():Void { 			f.apply( null, args ); 			_this.clear( ); 		};		_INTERVAL = setInterval( fn, ms );	}	/**	 * Clear TimeOut interval	 * @return Void	 */	public function clear():Void { 		clearInterval( INTERVAL );		} }