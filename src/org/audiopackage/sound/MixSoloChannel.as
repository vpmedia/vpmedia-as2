import org.audiopackage.sound.*;

class org.audiopackage.sound.MixSoloChannel extends BasicSound
{
	private var properties: Array;
	private var channelCount: Number;
	
	function MixSoloChannel( targetClip: MovieClip )
	{
		super( targetClip );
		
		properties = new Array;
		
		channelCount = 1;
	}
	
	function start(): Boolean
	{
		return super.start.apply( super, arguments );
	}
	
	function stop( Void ): Void
	{
		super.stop();
	}
	
	function mix( volume: Number, pan: Number ): Void
	{
		properties.push( arguments );
		
		if( properties.length == channelCount )
		{
			var c: Number = channelCount;
			var p: Array;
			var newVolume: Number;
			var mixedVolume: Number = 0;
			var mixedPan: Number 	= 0;
			
			while( --c > -1 )
			{
				p = properties[c];
				
				newVolume = p[0];
				
				mixedVolume += ( newVolume - mixedVolume ) / 100 * newVolume;
				mixedPan += ( p[1] - mixedPan ) / 100 * newVolume;
			}
			
			super.setVolume( mixedVolume );
			super.setPan( mixedPan );
			
			properties = new Array;
		}
	}
	
	function setChannelCount( count: Number ): Void
	{
		this.channelCount = count;
	}
}