import org.audiopackage.sound.*;

/*
* CONTROL SOUND INSTANCES WITH SEPARATE CHANNELS
*/

class org.audiopackage.sound.SplitSound extends BasicSound
{
	private var vols: Array;
	private var pans: Array;
	
	private var transform: Object;
	
	function SplitSound( targetClip )
	{
		super( targetClip );
		
		vols = [ 100 , 100 ];
		pans = [ 0 , 0 ];
		
		transform = new Object();
	}
	
	function start(): Boolean
	{
		return super.start.apply( super, arguments );
	}
	
	function stop( Void ): Void
	{
		super.stop();
	}
	
	function setVolume( volume: Number, channel: Number ): Void
	{
		vols[ channel ] = volume;
		
		var panFloat: Number = ( pans[ channel ] + 100 ) / 200;
		
		switch( channel )
		{
			case 0:
			
				transform.ll = ( 1 - panFloat ) * volume;
				transform.rl = panFloat * volume;
				
				break;
				
			case 1:
			
				transform.lr = ( 1 - panFloat ) * volume;
				transform.rr = panFloat * volume;
				
				break;
		}
		
		super.setTransform( transform );
	}
	
	function getVolume( channel: Number ): Number
	{
		return vols[ channel ];
	}
	
	function getPan( channel: Number ): Number
	{
		return pans[ channel ];
	}
	
	function setPan( pan: Number, channel: Number ): Void
	{
		var panFloat: Number = ( ( pans[ channel ] = pan ) + 100 ) / 200;
		
		var volume: Number = vols[ channel ];
		
		switch( channel )
		{
			case 0:
			
				transform.ll = ( 1 - panFloat ) * volume;
				transform.rl = panFloat * volume;
				
				break;
				
			case 1:
			
				transform.lr = ( 1 - panFloat ) * volume;
				transform.rr = panFloat * volume;
				
				break;
		}
		
		super.setTransform( transform );
	}
}