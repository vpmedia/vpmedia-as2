import org.audiopackage.sound.BasicSound;
import org.audiopackage.sync.ISyncSource;
import org.audiopackage.sync.ISyncListener;

/*
* * OSCSync = onSoundComplete Sync

* * Enables a sample exact BPM and Shuffle
* * should run fine on Win2k and WinXP
* * Samples must have 50 ms Silence at beginning
* * 
* * Initial Idea:
* * http://www.active-web.cc/html/research/f6sync/f6sync.txt
*/

class org.audiopackage.sync.OSCSync extends BasicSound
	implements ISyncSource
{
	static var DEFAULT_BPM: Number = 130;
	static var DEFAULT_SHUFFLE: Number = 0;

	private var BPM: Number;
	private var shuffle: Number;
	
	private var wavOffset = .05;
	
	private var timer: Number;
	private var si: Number;
	private var scT: Number;
	
	private var listeners: Array;
	
	function OSCSync ( targetClip: MovieClip )
	{
		super( targetClip );
		attachSound( "OSCSync" );
		setVolume( 0 );
		
		BPM = DEFAULT_BPM;
		shuffle = DEFAULT_SHUFFLE;
		
		listeners = new Array();
	}
	function startSync( Void ): Void
	{
		timer = 0;
		si = 0;
		scT = 2048 / 44.1;
		
		super.start( 0 , 1 );
	}
	function stopSync( Void ): Void
	{
		super.stop();
	}
	function setBPM ( value: Number ): Void
	{
		BPM = value;
	}
	function getBPM (): Number
	{
		return BPM;
	}
	function setShuffle ( value: Number ): Void
	{
		shuffle = value;
	}
	function getShuffle (): Number
	{
		return shuffle;
	}
	function onSoundComplete (): Void
	{	
		this.start( 0 , 1 );
		
		var bpmT = 15000 / BPM;
		if ( si ) { bpmT += bpmT / 100 * shuffle } else { bpmT -= bpmT / 100 * shuffle };
		timer += scT;
		
		if ( timer > bpmT )
		{
			timer %= bpmT;
			si = 1 - si;
			broadcastMessage( 'onSync', wavOffset - ( scT - timer ) / 1000 );
		}
	}
	
	function addListener( listener: ISyncListener ): Void
	{
		listeners.push( listener );
	}
	
	function removeListener( listener: ISyncListener ): Boolean
	{
		var l: Number = listeners.length;
		
		while( --l > -1 )
		{
			if( listeners[l] == listener )
			{
				listeners.splice( l , 1 );
				return true;
			}
		}
		return false;
	}
}
