import org.as2base.event.*;

class org.as2base.app.Flapp
{
	static private var DEPTH_CLIPMASK: Number = 10000;
	static private var DEPTH_BORDER: Number = 10001;
	static private var DEPTH_FPS: Number = 10002;
	
	private var timeline: MovieClip;	
	private var width: Number;
	private var height: Number;
	
	private var clipMask: MovieClip;
	private var borderClip: MovieClip;
	
	function Flapp( timeline: MovieClip, width: Number, height: Number )
	{
		this.timeline = timeline;
		this.width = width || Stage.width;
		this.height = height || Stage.height;
		
		Impulse.initialize( timeline );
	}

	function getNewTimeline( depth: Number, linkageId: String ): MovieClip
	{
		if( arguments.length > 1 )
		{
			return timeline.attachMovie( linkageId, depth.toString() , depth );
		}

		return timeline.createEmptyMovieClip( depth.toString() , depth );
	}
	
	function getNewTextField(): TextField
	{
		timeline.createTextField.apply( timeline, arguments );
		
		return timeline[ arguments[0] ];
	}
	
	function setClipping( clip: Boolean ): Void
	{
		switch( clip )
		{
			case true:
			
				clipMask = timeline.createEmptyMovieClip( 'clipMask' , DEPTH_CLIPMASK );
				
				clipMask.beginFill( 0 );
				clipMask.moveTo( 0 , 0 );
				clipMask.lineTo( width , 0 );
				clipMask.lineTo( width , height );
				clipMask.lineTo( 0 , height );
				clipMask.lineTo( 0 , 0 );
				clipMask.endFill();
				
				timeline.setMask( clipMask );
				break;
				
			case false:
			
				timeline.setMask( null );
				clipMask.removeMovieClip();
				delete clipMask;
				break;
		}
	}
	
	function setBorder( border: Boolean ): Void
	{
		switch( border )
		{
			case true:
			
				borderClip = timeline.createEmptyMovieClip( 'borderClip' , DEPTH_BORDER );
				
				borderClip.lineStyle( 0 , 0xff0000 );
				borderClip.moveTo( 0 , 0 );
				borderClip.lineTo( width - 1 , 0 );
				borderClip.lineTo( width - 1 , height - 1 );
				borderClip.lineTo( 0 , height - 1 );
				borderClip.lineTo( 0 , 0 );

				break;
				
			case false:
			
				borderClip.removeMovieClip();
				delete borderClip;
				break;
		}
	}
	
	function getWidth( Void ): Number
	{
		return width;
	}
	
	function getHeight( Void ): Number
	{
		return height;
	}
	
	function getTimeline( Void ): MovieClip
	{
		return timeline;
	}
	
	function execute(){}
	
	//-- Util
	//
	function showFPS( Void ): Void
	{
		var fps: TextField = getNewTextField( 'fps' , DEPTH_FPS , 0 , 0 , 12 , 12 );

		fps.autoSize = true;
		fps.background = true;
		fps.backgroundColor = 0x000000;
		fps.border = true;
		fps.borderColor = 0xffff00;
		
		var tf: TextFormat = new TextFormat();
	
		tf.size = 10;
		tf.font = "Courier";
		tf.color = 0xffff00;
		
		fps.setNewTextFormat( tf );
		
		var frame: Number = 0;
		var ms: Number = getTimer();
		
		new Recall( this , function()
		{
			if( getTimer() - ms > 1000 )
			{
				fps.text = frame.toString();
				frame = 0;
				ms = getTimer();
			} else ++frame;
		}).start();

		fps.text = "--";
	}
	
	//-- SERVER STRUCTURE
	//
	function getFolderPath( Void ): String
	{
		return timeline._url.substr( 0, timeline._url.lastIndexOf( '/' ) + 1 );
	}
	
	//-- PROTECTION
	//
	function lockDomain( url: String ): Void
	{
		if( _level0._url.indexOf( url ) == -1 )
		{
			unloadMovieNum(0);
		}
	}
	
	function lockSize( width: Number, height: Number ): Void
	{
		if( !( Stage.width == width && Stage.height == height ) )
		{
			unloadMovieNum(0);
		}
	}
}
