import net.manaca.media.IPlayer;
import net.manaca.lang.BObject;
import net.manaca.util.Delegate;
/****************************************************************************
*
*			1---------------------------------------------------------l
*		   |	 Wersling		O	o	O O O O O O     	00   	   |
*			l------------------------------------------------|--------l
*															S S	
*														   S	S
*						/○\ ●								S S
*						/■\/■\							 v
*			   	 ╪═╪  <|　||								 |
*
*****************************************************************************
* @class net.manaca.media.VMP3
* @author Wersling
* @version 1.0
* @description 扩展Sound类，使之更容易使用
* @usage       <pre>var inst:VMP3 = new VMP3();</pre>
* -----------------------------------------------
* Latest update: 2005-4-19
*  --------------------------------------------------
*/
//
class net.manaca.media.VMP3 extends BObject implements IPlayer{
	//
	private var _mp3 : Sound;
	private var _url : String = "";
	//
	private var _TotalTime : String;
	private var _NowTime : String;
	private var _recentPosition : Number = 0;
	private var _intervalID : Number;
	private var _percentLoaded : Number;
	private var _id3Info : Object;
	private var _isPlay : Boolean;
	private static var $volume : Number;
	private static var $pan : Number;
	private static var $transform : Object;
	//
	//  构造函数
	//
	public function VMP3 ()
	{
		_mp3	= new Sound ();
		_mp3.onLoad = Delegate.create (this, onSuccess);
		_mp3.onID3 = Delegate.create (this, onid3);
		_mp3.onSoundComplete = Delegate.create (this, onMp3Complete);
	}
	//
	//10.	load(path,isStreaming) ----加载MP3------------
	//
	public function load (path : String, isStreaming : Boolean) : Void
	{
		_url = path;
		_mp3.loadSound (_url, isStreaming);
		if (isStreaming)
		{
			_isPlay = true;
		} else
		{
			_isPlay = false;
		}
		Tracer.debug("#VMP3# " + "开始加载 " + path);
		_intervalID = setInterval (Delegate.create (this, checkProgress) , 80);
		dispatchEvent ( 
		{
			type : "VMLprogress", value : 0
		});
	}
	//
	//11.	checkProgress() -------------加载进度-------------
	//
	private function checkProgress () : Void
	{
		var bytesLoaded : Number = _mp3.getBytesLoaded ();
		if (bytesLoaded == 0)
		{
			return;
		}
		var bytesTotal : Number = _mp3.getBytesTotal ();
		if (bytesTotal == undefined)
		{
			return;
		}
		var percentLoaded : Number = Math.floor ((bytesLoaded / bytesTotal ) * 100);
		if (_percentLoaded != percentLoaded)
		{
			_percentLoaded = percentLoaded;
			Tracer.debug ("#VMP3# " + "正在加载 " + _url + "进度 " + _percentLoaded + "%");
			dispatchEvent ( 
			{
				type : "VMLprogress", value : _percentLoaded
			});
		}
	}
	//
	//12.  onSuccess(success) -----判断是否加载成功 -------------
	//
	private function onSuccess (success)
	{
		if (success)
		{
			clearInterval (_intervalID);
			if (_percentLoaded < 100)
			{
				dispatchEvent ( 
				{
					type : "progress", value : 100
				});
				Tracer.debug ("#VMP3# " + "正在加载 " + _url + "进度100%");
			}
			Tracer.debug ("#VMP3# " + "加载 " + _url + "完成!");
			dispatchEvent ( 
			{
				type : "VMLcomplete"
			});
		} else
		{
			clearInterval (_intervalID);
			Tracer.debug ("#VMP3# " + "加载 " + _url + "失败!");
			dispatchEvent ( 
			{
				type : "VMLfailed"
			});
		}
	}
	//
	//13.  onid3() ----------------是否有新的ID3信息 -------------
	//
	private function onid3 (info) : Void
	{
		for (var i in info)
		{
			//_id3Info [i] = VString.toUTF (info [i]);
		}
		dispatchEvent ( 
		{
			type : "onid3", value : _id3Info
		});
	}
	//
	//12.  onMp3Complete() --------MP3播放完毕---------------------
	//
	private function onMp3Complete () : Void
	{
		dispatchEvent ( 
		{
			type : "onMp3Complete"
		});
	}
	//
	//14.  play() ---------------------播放---------------------
	//
	public function play () : Void
	{
		_mp3.start (int (_recentPosition / 1000) , 1);
		_isPlay = true;
		Tracer.debug ("#VMP3# " + "开始播放 " + _url);
		dispatchEvent ( 
		{
			type : "mp3Play"
		});
	}
	//
	//15.  pause() ---------------------暂停---------------------
	//
	public function pause () : Void
	{
		_recentPosition = _mp3.position;
		_mp3.stop ();
		_isPlay = false;
		Tracer.debug ("#VMP3# " + "暂停播放 " + _url + "在：" + _recentPosition);
		dispatchEvent ( 
		{
			type : "mp3Pause"
		});
	}
	//
	//16.  stop() ---------------------停止---------------------
	//
	public function stop () : Void
	{
		_recentPosition = 0;
		_mp3.stop ();
		_isPlay = false;
		Tracer.debug ("#VMP3# " + "停止播放 " + _url);
		dispatchEvent ( 
		{
			type : "mp3Stop"
		});
	}
	//
	//17.  playPosition() --------------播放指定位置---------------------
	//
	public function playPosition (n : Number) : Void
	{
		_recentPosition = n;
		_mp3.start (_recentPosition, 1);
		_isPlay = true;
		Tracer.debug ("#VMP3# " + "播放 " + _url + "位置在：" + n);
		dispatchEvent ( 
		{
			type : "mp3Play"
		});
	}
	//
	// 1. get url ----------------获取路径----------------
	//
	public function get url () : String
	{
		return _url;
	}
	//
	//3.  get NowTime() ---------获取播放时间-------------
	//
	public function get NowTime () : String
	{
		return null;
		//return Format.FormatTime (_mp3.position);
	}
	//
	//4.  get TotalTime() --------获取总时间--------------
	//
	public function get TotalTime () : String
	{
		return null;
		//return Format.FormatTime (_mp3.duration);
	}
	//
	//5.  get position() ----------获取播放时间（毫秒）----
	//
	public function get position () : Number
	{
		return _mp3.position;
	}
	//
	//6.  get duration() ----------获取总时间（毫秒）----
	//
	public function get duration () : Number
	{
		return _mp3.duration;
	}
	//
	//7.  set volume(n) ------------设置音量--------------
	//
	public function set volume (n : Number) : Void
	{
		$volume = n;
		_mp3.setVolume ($volume);
	}
	//
	//8.  set Pan(n) ---------------设置均衡--------------
	//
	public function set Pan (n : Number) : Void
	{
		_mp3.setPan (n);
	}
	//
	//9.	set Transform(a,b,c,d) -------声音转换（即，均衡）信息--------------
	//
	public function Transform (a : Number, b : Number, c : Number, d : Number) : Void
	{
		var Obj = new Object;
		Obj.ll	= a;
		Obj.lr	= b;
		Obj.rr	= c;
		Obj.rl	= d;
		_mp3.setTransform (Obj);
	}
	//
	//	get isPlay () ---------------获取是否播放-------------
	//
	public function get isPlay () : Boolean
	{
		return _isPlay;
	}
	public function set isPlay (value : Boolean)
	{
		if (value)
		{
			play ();
		} else
		{
			pause ();
		}
	}
}
