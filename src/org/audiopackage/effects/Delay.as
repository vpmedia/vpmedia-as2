import org.audiopackage.sync.ISyncSource;
import org.audiopackage.sync.ISyncListener;
import org.audiopackage.sound.BasicSound;
import org.audiopackage.sound.ISoundSource;
import org.audiopackage.sound.ISoundListener;

class org.audiopackage.effects.Delay
	implements ISyncListener, ISoundListener
{
	static private var BUFFER_LENGTH: Number = 32;
	static private var DEFAULT_RATE: Number = 5;
	static private var DEFAULT_DAMP: Number = .2;
	static private var CUT_VOLUME: Number = 1;
	
	private var sync: ISyncSource;	
	private var source: ISoundSource;
	private var output: ISoundSource;
		
	private var damp: Number;
	private var rate: Number;
	
	private var echoes: Array;
	private var timer: Number;
	
	function Delay( sync: ISyncSource, source: ISoundSource )
	{
		this.sync = sync;

		echoes = new Array;
		timer = 0;
		
		rate = DEFAULT_RATE;
		damp = DEFAULT_DAMP;
	}
	
	function setSource( source: ISoundSource )
	{
		this.sync.removeListener( this );
		this.source.removeListener( this );
		
		if ( source != null )
		{
			output = source.clone( source.getTargetClip().createEmptyMovieClip( 'delay_tc' , 0 ) );
			output.attachSound( source.getLinkageId() );
			
			sync.addListener( this );
			source.addListener( this );
		}
		this.source = source;
	}
	
	function setRate( rate: Number ): Void
	{
		if ( rate > 0 && rate < BUFFER_LENGTH ) this.rate = rate;
	}
	
	function getRate( Void ): Number
	{
		return rate;
	}
	
	function setDamp( damp: Number ): Void
	{
		if ( damp >= 0 && damp < 1 ) this.damp = damp;
	}
	
	function getDamp( Void ): Number
	{
		return damp;
	}
	
	function onSync( delay: Number ): Void
	{
		timer++;
		timer %= BUFFER_LENGTH;
		
		var echo = echoes[ timer ];
		
		if ( echo )
		{
			output.setVolume( echo.volume );
			output.setPan( echo.pan );
			output.start( delay , 1 );
			delete echoes[ timer ];
		}
	}
	
	function onStart( sound: ISoundSource, delay: Number ): Void
	{
		if ( sound == source )
		{
			var vol: Number = source.getVolume();
			var pan: Number = source.getPan();
			
			var t: Number = timer;

			while( ( vol *= damp ) > CUT_VOLUME )
			{
				if ( ( t += rate ) > BUFFER_LENGTH - 1 ) t -= BUFFER_LENGTH;
				
				if ( echoes[ t ].volume > vol ) break;
				
				echoes[ t ] = { volume: vol, pan: pan };
			}
		}
	}
}
















