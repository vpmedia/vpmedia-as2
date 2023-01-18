/****************************************************************************
*
*			1---------------------------------------------------------l
*		   |	 Wersling		O	o	O O O O O O     	 00   	  |
*			l------------------------------------------------|--------l
*															S S	
*														   S	S
*						/○\ ●								S S
*						/■\/■\							 v
*			   	 ╪═╪  <|　||								 |	FLASH DESIGN
*****************************************************************************
* @class com.wersling.media.VFLV
* @author Wersling
* @version 1.0
* @description 控制并播放FLV文件。
* @usage       <pre>var inst:VFLV = new VFLV();</pre>
* -----------------------------------------------
* Latest update: 2005-7-15
* -----------------------------------------------
*   Functions:
*       VFLV()
*            1.  onNSStatus()
* 			 2.	 checkProgress()
* 			 3.	 load()
*			 4.	 play()
* 			 5.	 Positionplay()
* 			 6.	 pause()
* 			 7.	 stop()
* 			 8.	 get isPlay()
* 			 9.	 get NowTime()
* 			 10. get time()
* 			 11. get TotalTime()
* 			 12. get volume(n)
*  --------------------------------------------------
*/

import net.manaca.util.Delegate;
import net.manaca.media.IPlayer;
import net.manaca.lang.BObject;
//
class net.manaca.media.VFLV extends BObject implements IPlayer
{
	private var _nc : NetConnection;
	private var _ns : NetStream;
	private var _url : String;
	private var _Time : Number;
	private var _totalTime:Number;
	private var _intervalID : Number;
	private var _percentLoaded : Number;
	private var _isPlay : Boolean;
	//
	private var _sound : Sound;
	private var _videoHolder : MovieClip;
	//
	//构造函数
	//
	public function VFLV (my_video : Video, videoHolder : MovieClip)
	{
		_nc = new NetConnection ();
		_nc.connect (null);
		_ns = new NetStream(_nc);
		_ns.setBufferTime (5);
		my_video.attachVideo (_ns);
		//
		_videoHolder = videoHolder;
		_sound = new Sound (_videoHolder);
		_videoHolder.attachAudio (_ns);
		_ns.onStatus = Delegate.create (this, onNSStatus);
		_ns["onMetaData"] = Delegate.create (this, onNSMetaData);
		_ns["onLastSecond"] = Delegate.create (this, onNSLastSecond);
	}
	//
	//onNSStatus (info) ----------检测数据加载-----------
	//
	private function onNSStatus (info : Object) : Void
	{
		if (info.level != "Error")
		{
			switch (info.code)
			{
				case "NetStream.Buffer.Empty" :
				Tracer.debug ("#VFLV# " + "正在下载数据……");
				dispatchEvent (
				{
					type : "onFlvEmpty"
				});
				break;
				case "NetStream.Buffer.Full" :
				Tracer.debug ("#VFLV# " + "正在播放");
				dispatchEvent (
				{
					type : "onFlvPlay"
				});
				break;
				case "NetStream.Play.Start" :
				Tracer.debug ("#VFLV# " + "回放已开始。");
				dispatchEvent (
				{
					type : "onFlvStart"
				});
				break;
				case "NetStream.Play.Stop" :
				Tracer.debug ("#VFLV# " + "回放已结束。");
				dispatchEvent (
				{
					type : "onFlvComplete"
				});
				break;
			}
		} else
		{
			Tracer.debug ("#VFLV# " + "加载 " + _url + " 失败！");
			dispatchEvent (
			{
				type : "failed"
			});
		}
	}
	//
	//checkProgress() -------------加载进度-------------
	//
	private function checkProgress () : Void
	{
		var bytesLoaded : Number = _ns.bytesLoaded;
		if (bytesLoaded == 0)
		{
			return;
		}
		var bytesTotal : Number = _ns.bytesTotal;
		if (bytesTotal == undefined)
		{
			return;
		}
		var percentLoaded : Number = Math.floor ((bytesLoaded / bytesTotal ) * 100);
		if (_percentLoaded != percentLoaded)
		{
			_percentLoaded = percentLoaded;
			//Tracer.trace ("#VFLV# " + "正在加载 " + _url + "进度 " + _percentLoaded + "%");
			dispatchEvent (
			{
				type : "progress", value : _percentLoaded
			});
		}
	}
	//
	//	load (path) --------------加载FLV文件-----------
	//
	public function load (path : String) : Void
	{
		_url = path;
		_ns.play (_url);
		_isPlay = true;
		_intervalID = setInterval (Delegate.create (this, checkProgress) , 80);
	}
	//
	//	play() ---------------------播放-------------
	//
	public function play () : Void
	{
		_ns.pause (false);
		_isPlay = true;
	}
	//
	//	pause() --------------------暂停-------------
	//
	public function pause () : Void
	{
		_Time = _ns.time;
		_ns.pause (true);
		_isPlay = false;
	}
	//
	//	stop() ---------------------停止-------------
	//
	public function stop () : Void
	{
		_Time = 0;
		_ns.seek(0);
		_ns.pause();
		_isPlay = false;
	}
	//
	//	close() -------------------删除流数据-------------
	//
	public function close () : Void
	{
		_ns.close();
	}
	//
	//	playPosition (n) -------------播放指定位置-------------
	//
	public function playPosition (n : Number) : Void
	{
		_ns.seek (n);
		_isPlay = true;
	}
	//
	// get url ----------------获取路径----------------
	//
	public function get url () : String
	{
		return _url;
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
	//
	//	get time ()  -------------获取播放进度（秒）-----------
	//
	public function get time () : Number
	{
		return _ns.time;
	}
	//
	//get volume() -------------------获取音量------------
	//
	public function get volume () : Number
	{
		return _sound.getVolume ();
	}
	//
	//set volume(n) -------------------设置音量------------
	//
	public function set volume (n : Number) : Void
	{
		_sound.setVolume (n);
	}
	/**
	 * 获取总时间
	 */
	public function get TotalTime ()
	{
		return _totalTime;
	}
	/**
	 * 获取播放时间
	 */
	public function get NowTime () : String
	{
		return null;
		//return Format.FormatTime (_ns.time * 1000);
	}
	//
	private function onNSMetaData(Obj:Object)
	{
		_totalTime = Obj.duration;
	}
	private function onNSLastSecond(Obj:Object)
	{
		//for(var i in Obj) trace('key: ' + i + ', value: ' + Obj[i]);
	}
}
