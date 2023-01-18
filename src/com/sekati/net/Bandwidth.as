/**
 * com.sekati.net.Bandwidth
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.time.StopWatch;
import com.sekati.utils.Delegate;
/**
 * Simple bandwidth throughput test
 * {@code Usage:
 * function bandwidthResult(speed:Number, testsize:Number, ms:Number){
 * 	trace("bandwidth speed: "+speed+"kbps, test filesize: "+testsize+", test time: "+ms+"ms");
 * }
 * var bandwidthTest = new com.sekati.net.Bandwidth("assets/bandwidth_data/50k", bandwidthResult);
 * } 
 */
class com.sekati.net.Bandwidth extends CoreObject {
	private var _timer:StopWatch;
	private var _cb:Function;
	private var _con:LoadVars;	
	/**
	 * constructor
	 * @param uri (String) uri to bandwidth test file (should be non tcp/ip compressable random "junk data" see deploy/assets/bandwidth_data) 
	 * @param cb (Function) callback function for test to return speed, filesize, ms results.
	 */
	public function Bandwidth(uri:String, cb:Function) {
		super( );
		_cb = cb;
		_timer = new StopWatch( true );
		_con = new LoadVars( );
		_con.onLoad = Delegate.create( this, testLoaded );
		_con.load( uri + "?" + Math.random( ) );		
	}
	private function testLoaded(success:Boolean):Void {
		if (success) {
			var ms:Number = _timer.stop( );
			var filesize:Number = _con.getBytesTotal( );
			var speed:Number = Math.round( (filesize / 1024 * 8) / (ms / 1000) );
			_cb( speed, filesize, ms );	
		} else {
			throw new Error( "@@@ " + this.toString( ) + " Error: data file loading failed." );
		}
	}
}