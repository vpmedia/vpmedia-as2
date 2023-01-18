import org.audiopackage.sync.ISyncSource;
import org.audiopackage.sync.ISyncListener;
import org.audiopackage.sound.BasicSound;
import org.audiopackage.sound.ISoundSource;
import org.audiopackage.sound.ISoundListener;

class org.audiopackage.effects.Flanger
	implements ISyncListener, ISoundListener
{
	static private var DEFAULT_SPEED: Number = .04;
	static private var DEFAULT_RANGE: Number = .001;
	static private var DAMP_VOLUME: Number = .6;

	private var sync: ISyncSource;
	private var source: ISoundSource;
	private var output: ISoundSource;
	
	private var timer: Number;
	private var range: Number;
	private var speed: Number;
	
	private var r2: Number;
	
	function Flanger( sync: ISyncSource )
	{
		this.sync = sync;

		timer = 0;
		
		setSpeed( DEFAULT_SPEED );
		setRange( DEFAULT_RANGE );
	}
	
	function setSource( source: ISoundSource )
	{
		this.sync.removeListener( this );
		this.source.removeListener( this );
		
		if ( source != null )
		{
			output = source.clone( source.getTargetClip().createEmptyMovieClip( 'flanger_tc' , 1 ) );
			output.attachSound( source.getLinkageId() );
			
			sync.addListener( this );
			source.addListener( this );
		}
		this.source = source;
	}
	
	function setRange( range: Number ): Void
	{
		if ( range > 0 && range < 1 )
		{
			this.range = range;
			r2 = range / 2;
		}
	}
	
	function getRange( Void ): Number
	{
		return range;
	}
	
	function setSpeed( speed: Number ): Void
	{
		if( speed > 0 && speed < Math.PI ) this.speed = speed;
	}
	
	function getSpeed( Void ): Number
	{
		return speed;
	}
	
	function onSync( delay: Number ): Void
	{
		timer += speed;
	}
	
	function onStart( sound: ISoundSource, delay: Number ): Void
	{
		if ( sound == source )
		{
			var dampVolume: Number = source.getVolume()// * DAMP_VOLUME;
			
			source.setVolume( dampVolume );
			output.setVolume( dampVolume );
			
			output.start( delay + Math.sin( timer ) * r2 + r2 , 1 );
		}
	}
}