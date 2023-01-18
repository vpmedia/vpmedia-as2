import org.audiopackage.sound.BasicSound;
import org.audiopackage.sync.ISyncListener;

/*
This is a dummy application for the dummy XML Parser :o)
Just working on a better parsing system...
*/

class org.audiopackage.app.GSequencer
	implements ISyncListener
{
	private var BasicSounds: Array;
	private var track: Array;
	
	private var ticksPer16: Number = 1920 * 2;
	private var timer: Number;
	
	function GSequencer()
	{
		timer = 0;
		BasicSounds = new Array();
	}
	
	function addChannelListener( sound: BasicSound, channel: Number ): Void
	{
		BasicSounds[ channel ] = sound;
	}
	
	function onSync( delay: Number ): Void
	{
		var events: Array = track[ timer ];
		
		var n = events.length;
		
		while( --n > -1 )
		{
			var event = events[n];
			
			var sound = BasicSounds[ event.note ];
			sound.setVolume( event.vel );
			sound.start( delay , 1 );
		}
		timer += ticksPer16;
	}
	
	function setTrack( track: Array ): Void
	{
		this.track = track;
	}
}