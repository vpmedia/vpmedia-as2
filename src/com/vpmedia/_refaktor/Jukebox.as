/**
* Jukebox Class v1.0
* Author  : Mika Palmu
* Licence : Use freely, giving credit when you can.
* Website : http://www.meychi.com/
*/
class com.vpmedia.media.Jukebox
{
	/**
	* Variables
	*/
	public var onParse:Function;
	public var onError:Function;
	public var onSongComplete:Function;
	public var onSongLoad:Function;
	public var onSongPlay:Function;
	private var onPlayDelay:Number;
	private var pausePosition:Number = 0;
	private var pausePressed:Boolean = false;
	private var stopPressed:Boolean = false;
	private var mainSoundVolume:Number = 100;
	private var mainSoundPan:Number = 0;
	private var current:Number = 0;
	private var mainSound:Sound;
	private var container:Array;
	private var playlist:XML;
	/**
	* Constructor
	*/
	public function Jukebox ()
	{
		this.createSoundObject ();
		this.container = new Array ();
		this.playlist = new XML ();
		this.playlist.ignoreWhite = true;
	}
	/**
	* Starts the jubebox and plays the first song.
	*/
	public function start ():Void
	{
		this.current = 1;
		this.loadMP3 (this.getSongById (1).link);
	}
	/**
	* Starts to play the current song.
	*/
	public function play (time:Number):Void
	{
		if (time == undefined)
		{
			var startTime = this.pausePosition;
		}
		else
		{
			var startTime = time;
		}
		this.mainSound.start (startTime, 0);
		this.mainSound.setVolume (this.mainSoundVolume);
		this.mainSound.setPan (this.mainSoundPan);
		this.stopPressed = false;
		this.pausePressed = false;
		this.pausePosition = 0;
	}
	/**
	* Stops the current song.
	*/
	public function stop ():Void
	{
		this.mainSound.stop ();
		this.stopPressed = true;
		this.pausePressed = false;
		this.pausePosition = 0;
	}
	/**
	* Pauses the current song.
	*/
	public function pause ():Void
	{
		if (!this.stopPressed)
		{
			if (this.pausePressed)
			{
				this.play ();
				this.pausePressed = false;
			}
			else
			{
				this.pausePosition = this.mainSound.position / 1000;
				this.pausePressed = true;
				this.mainSound.stop ();
			}
		}
	}
	/**
	* Moves to the next song.
	*/
	public function next ():Void
	{
		this.createSoundObject ();
		if (this.current == container.length)
		{
			this.current = 1;
		}
		else
		{
			this.current += 1;
		}
		this.loadMP3 (this.getSongById (this.current).link, true);
	}
	/**
	* Moves to the previous song.
	*/
	public function previous ():Void
	{
		this.createSoundObject ();
		if (this.current == 1)
		{
			this.current = container.length;
		}
		else
		{
			this.current -= 1;
		}
		this.loadMP3 (this.getSongById (this.current).link, true);
	}
	/**
	* Rewinds the current sound, specified by the argument.
	*/
	public function rewind (time:Number):Void
	{
		this.play ((this.mainSound.position / 1000) - time / 1000);
	}
	/**
	* Moves the current sound forward, specified by the argument.
	*/
	public function forward (time:Number):Void
	{
		this.play ((this.mainSound.position / 1000) + time / 1000);
	}
	/**
	* Loads the specified mp3 to the jukebox.
	*/
	public function loadMP3 (link:String):Void
	{
		clearInterval (this.onPlayDelay);
		var reference = this;
		this.mainSound.loadSound (link, true);
		this.onPlayDelay = setInterval (function ()
		{
			if (reference.mainSound.position > 1)
			{
				clearInterval (reference.onPlayDelay);
				reference.onSongPlay ();
			}
		}, 10, this);
		this.mainSound.setVolume (this.mainSoundVolume);
		this.mainSound.setPan (this.mainSoundPan);
	}
	/**
	* Sets the volume of the jukebox.
	*/
	public function setVolume (volume:Number):Void
	{
		this.mainSoundVolume = volume;
		this.mainSound.setVolume (volume);
	}
	/**
	* Sets the pan of the jukebox.
	*/
	public function setPan (pan:Number):Void
	{
		this.mainSoundPan = pan;
		this.mainSound.setPan (pan);
	}
	/**
	* Gets the volume of the jukebox.
	*/
	public function getVolume ():Number
	{
		return this.mainSound.getVolume ();
	}
	/**
	* Gets the pan of the jukebox.
	*/
	public function getPan ():Number
	{
		return this.mainSound.getPan ();
	}
	/**
	* Gets the duration of the current song.
	*/
	public function getDuration ():Number
	{
		return this.mainSound.duration;
	}
	/**
	* Gets the position of the current song.
	*/
	public function getPosition ():Number
	{
		return this.mainSound.position;
	}
	/**
	* Gets the percent played of the current song.
	*/
	public function getPercentPlayed ():Number
	{
		if (this.mainSound.position != null && !this.stopPressed)
		{
			return Math.round (this.mainSound.position / this.mainSound.duration * 100);
		}
		else
		{
			return 0;
		}
	}
	/**
	* Gets the percent loaded of the current song.
	*/
	public function getPercentLoaded ():Number
	{
		if (this.mainSound.position != null)
		{
			return Math.round (this.mainSound.getBytesLoaded () / this.mainSound.getBytesTotal () * 100);
		}
		else
		{
			return 0;
		}
	}
	/**
	* Gets the playlist in an array.
	*/
	public function getPlaylist ():Array
	{
		return this.container;
	}
	/**
	* Gets the current song of the jukebox.
	*/
	public function getCurrentSong ():Object
	{
		return this.getSongById (this.current);
	}
	/**
	* Gets a song from the playlist specified by id.
	*/
	public function getSongById (id:Number):Object
	{
		if (this.container[id - 1] != undefined)
		{
			return this.container[id - 1];
		}
		else
		{
			this.onError ("wrong_song_id");
		}
	}
	/**
	* Loads the XML playlist to the jukebox.
	*/
	public function loadPlaylist (link:String):Void
	{
		var reference = this;
		this.playlist.onLoad = function (success)
		{
			if (success)
			{
				reference.parsePlaylist ();
			}
			else
			{
				reference.onError ("xml_loading_failed");
			}
		};
		this.playlist.load (link);
	}
	/**
	* Creates a mainSound object for the jukebox.
	*/
	private function createSoundObject ():Void
	{
		var reference = this;
		this.mainSound = new Sound ();
		this.mainSound.onSoundComplete = function ()
		{
			reference.createSoundObject ();
			reference.onSongComplete ();
		};
		this.mainSound.onLoad = function (success)
		{
			if (success)
			{
				reference.onSongLoad ();
			}
			else
			{
				reference.onError ("mp3_load_failed");
			}
		};
	}
	/**
	* Parses the playlist to an array.
	*/
	private function parsePlaylist ():Void
	{
		var mainNode:XMLNode = this.playlist.firstChild;
		var songNode:XMLNode = this.playlist.firstChild.firstChild;
		while (songNode != null)
		{
			var songSubNode:XMLNode = songNode.firstChild;
			while (songSubNode != null)
			{
				if (songSubNode.nodeName == "artist")
				{
					var artist:String = songSubNode.firstChild.toString ();
				}
				else if (songSubNode.nodeName == "title")
				{
					var title:String = songSubNode.firstChild.toString ();
				}
				else if (songSubNode.nodeName == "link")
				{
					var link:String = songSubNode.firstChild.toString ();
				}
				else
				{
					this.onError ("xml_wrong_node");
				}
				songSubNode = songSubNode.nextSibling;
			}
			this.container.push (new Object ({artist:artist, title:title, link:link}));
			songNode = songNode.nextSibling;
		}
		this.onParse ();
	}
}
