/**
 * Abstract Model 
 * use for Streaming Video Data
 * connects to a Video_Instance and VideoControlAsset View
 * connects to a VideoControl Controller 
 * 
 * USE SETTER _video with filename or with parameter 
 * within Constructor to invoke/change the stream
 * 
 * @author tPS
 * @version 1
 */
import NetConnection;
import NetStream;
import com.tPS.event.Delegate;
import com.tPS.event.AeventSource;
 
 
class com.tPS.ui.video.StreamingVideoModel extends AeventSource {
	private var _connection:NetConnection;
	private var _stream:NetStream;
	
	private var initDone:Boolean;
	public var playHalted:Boolean;
	private var vid_Props:Object;
	
	function StreamingVideoModel( $url:String ) {
		super();
		
		setup();
		
		if($url)
			init($url);
	}
	
	
	private function setup() : Void {
		_connection = new NetConnection();
		_connection.connect(null);
		_stream = new NetStream( _connection );
		
		_stream.onStatus = Delegate.create(this, onStreamStat);
		_stream.onMetaData = Delegate.create(this, onMetaData);
		
		initDone = false;		
	}
	
	
	private function init($url:String) : Void {
		initDone = false;
		_stream.setBufferTime(2);
		_stream.play($url, 0);
		
		if(playHalted){
			_stream.seek(0);
			_stream.pause(true);
			togglePlayMs(false);
		}
		
		broadcastMessage("onStreamInit", _stream);
	}
	
	
	
	/**
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 */
	private function onStreamStat( e:Object ) : Void {
		switch(e.code){
			/*
			 * STREAM CONTROL
			 */
			case "NetStream.Play.Start":			if(!playHalted)togglePlayMs(true);	
													break;
			case "NetStream.Play.Stop":				togglePlayMs(false);	
													break;
			/*
			 * BUFFER CONTROL
			 */
			case "NetStream.Buffer.Empty":			showBufferLoad(true);
													break;
			case "NetStream.Buffer.Full":			showBufferLoad(false);
													break;
			case "NetStream.Buffer.Flush":			//trace( this + " ---> _stream.Buffer.Flush");
													break;
			/*
			 * ERRORS
			 */
			case "NetStream.Play.StreamNotFound":	trace( this + " ---> stream not found");
													break;
			case "NetStream.Seek.InvalidTime":		trace( this + " ---> seeked to invalid Time");
													break;
			/*
			 * SEEK
			 */
			case "NetStream.Seek.Notify":			broadcastMessage("onSeek");
													break;		
										
			default:								trace(this + " ---> onStreamStat, code: " + e.code);
													break;
		}
	}
	
	
	private function onMetaData( e:Object ) : Void {
		vid_Props = e;
		broadcastMessage("onMetaData", vid_Props);
		initDone = true;
	}
	
	private function pauseStream( toPause:Boolean ) : Void {
		_stream.pause( toPause );
		togglePlayMs( !toPause );
	}
	
	private function togglePlayMs( toPlay:Boolean ) : Void {
		trace("video is playing: " + toPlay );
		broadcastMessage("togglePlay", toPlay );
	}
	
	private function showBufferLoad( toShow:Boolean ) : Void {
		broadcastMessage("onShowBuffer", toShow);
	}
	
	
	/*
	 * INTERFACE METHOD IMPLEMENTATIONS		INTERFACE METHOD IMPLEMENTATIONS		INTERFACE METHOD IMPLEMENTATIONS		
	 * INTERFACE METHOD IMPLEMENTATIONS		INTERFACE METHOD IMPLEMENTATIONS		INTERFACE METHOD IMPLEMENTATIONS		
	 * INTERFACE METHOD IMPLEMENTATIONS		INTERFACE METHOD IMPLEMENTATIONS		INTERFACE METHOD IMPLEMENTATIONS		
	 */
	private function onSeekerChange($t:Number) : Void {
		_stream.seek($t);
	}
	
	public function play() : Void {
		pauseStream( false );
	}
	
	/**
	 * GETTER SETTER	GETTER SETTER	GETTER SETTER	GETTER SETTER	
	 * GETTER SETTER	GETTER SETTER	GETTER SETTER	GETTER SETTER	
	 * GETTER SETTER	GETTER SETTER	GETTER SETTER	GETTER SETTER	
	 */
	public function set _video($url:String) : Void {
		init($url);
	}
	
	public function set _playArea( $vid:Video ) : Void {
		$vid.attachVideo(_stream);
	}
	
	public function get _videoProps() : Object {
		if( initDone ){
			return vid_Props;
		}else{
			return undefined;
		}
	}
	
	public function get stream() : NetStream {
		return _stream;
	}
	
	public function toString() : String {
		return "[StreamingVideoModel]";
	}

	public function reset() : Void {
		_stream.seek(0);
		
		if(playHalted){
			_stream.pause(true);
			togglePlayMs(false);
		}
		
		broadcastMessage("onStreamInit", _stream);
	}

}