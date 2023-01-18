import org.audiopackage.util.GBuffer;
import org.audiopackage.util.GDelimiter;
import org.audiopackage.util.ClipSupplier;
import org.audiopackage.sound.ISoundListener;

/*
* class BasicSound extends Sound
* extends SoundClass to have better control
* over the playing sounds. More than 8 playing
* Sounds are not allowed, so you cannot break
* a running soundloop accidentally.
* The Success of method:
* 	BasicSoundInstance.start();
* ...can be accessed in the return value (Boolean)
*/

import org.audiopackage.sound.ISoundSource;

class org.audiopackage.sound.BasicSound extends Sound
	implements ISoundSource
{
	private var buffer: GBuffer;
	private var delimiter: GDelimiter;
	private var targetClip: MovieClip;
	private var linkageId: String;
	private var busy: Boolean;
	private var o_onSoundComplete: Function;
	private var broadcastMessage: Function;

	function BasicSound( targetClip: MovieClip )
	{
		super( this.targetClip = ( targetClip == undefined ) ? ClipSupplier.getTargetClip() : targetClip );
		
		busy = false;
		delimiter = GDelimiter.getInstance();
		
		AsBroadcaster.initialize( this );
	}
	
	function attachSound( linkageId: String ): ISoundSource
	{
		super.attachSound( this.linkageId = linkageId );
		return this;
	}
	
	function start(): Boolean
	{
		if( !delimiter.isLimit() || getLinkageId() == undefined )
		{
			super.start.apply( this, arguments );
			delimiter.push();
			broadcastMessage.apply( this , ['onStart' , this ].concat( arguments ) );
			busy = true;
			buffer = new GBuffer( this );
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function stop( Void ): Void
	{
		if ( busy )
		{
			busy = false;
			delimiter.pop();
			super.stop();
		}
	}
	
	function setVolume( value: Number ): Void
	{
		super.setVolume( value );
	}
	
	function getVolume( Void ): Number
	{
		return super.getVolume();
	}
	
	function setPan( value: Number ): Void
	{
		super.setPan( value );
	}
	
	function getPan( Void ): Number
	{
		return super.getPan();	
	}

	
	function isBusy( Void ): Boolean
	{
		return busy;
	}
	
	function getTargetClip( Void ): MovieClip
	{
		return targetClip;
	}
	
	function getLinkageId( Void ): String
	{
		return linkageId;
	}
	
	function clone( targetClip: MovieClip ): ISoundSource
	{
		return new BasicSound( targetClip );
	}
	
	function addListener( listener: ISoundListener ): Void {};
	function removeListener( listener: ISoundListener ): Boolean { return null };
	
	function set onSoundComplete( f: Function ): Void
	{
		o_onSoundComplete = f;
	}
	
	function get onSoundComplete(): Function
	{
		if( arguments.caller == null )	//-- Call from Soundcard
		{
			busy = false;
			delimiter.pop();
			GBuffer.clear( buffer );
		}
		return o_onSoundComplete;
	}
}