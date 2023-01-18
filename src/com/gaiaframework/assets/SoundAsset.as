/**********************************************************************************************************************
* Gaia Framework for Adobe Flash ©2007
* Written by: Steven Sacks
* email: stevensacks@gmail.com
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaframework.com/
* By using the Gaia Framework, you agree to keep the above contact information in the source code.

Distributed under Creative Commons Attribution-ShareAlike 3.0 Unported License
http://creativecommons.org/licenses/by-sa/3.0/

THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE ("CCPL" OR "LICENSE"). 
THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS 
LICENSE OR COPYRIGHT LAW IS PROHIBITED.

BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS OF THIS LICENSE. 
TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN 
CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**********************************************************************************************************************/

import com.gaiaframework.assets.AbstractAsset;
import mx.utils.Delegate;

class com.gaiaframework.assets.SoundAsset extends AbstractAsset
{
	private var _clip:MovieClip;
	private var _sound:Sound;
	
	function SoundAsset()
	{
		super();
	}
	public function get sound():Sound
	{
		return _sound;
	}
	public function init(target:MovieClip):Void
	{
		isActive = true;
		_clip = target;
		_sound = new Sound(_clip);
	}
	public function preload():Void
	{
		_sound.loadSound(src, true);
		_sound.stop();
		super.load();
	}
	public function load():Void
	{
		_sound.stop();
		_sound.loadSound(src, true);
	}
	public function getBytesLoaded():Number
	{
		return _sound.getBytesLoaded();
	}
	public function getBytesTotal():Number
	{
		return _sound.getBytesTotal();
	}
	public function destroy():Void
	{
		delete _sound;
		_clip.removeMovieClip();
		_clip = null;
		super.destroy();
	}
	public function retry():Void
	{
		_sound.loadSound(src, true);
		_sound.stop();
	}
	
	// PROXY SOUND PROPS/FUNCS
	public function loadSound(url:String, isStreaming:Boolean):Void
	{
		_sound.loadSound(url, isStreaming);
	}
	public function start(secondOffset:Number, loops:Number):Void
	{
		_sound.start(secondOffset, loops);
	}
	public function stop():Void
	{
		_sound.stop();
	}
	public function getVolume():Number
	{
		return _sound.getVolume();
	}
	public function setVolume(value:Number):Void
	{
		_sound.setVolume(value);
	}
	public function get duration():Number
	{
		return _sound.duration;
	}
	public function getPan():Number
	{
		return _sound.getPan();
	}
	public function setPan(value:Number):Void
	{
		_sound.setPan(value);
	}
	public function get position():Number
	{
		return _sound.position;
	}
	public function getTransform():Object
	{
		return _sound.getTransform();
	}
	public function setTransform(transformObject:Object):Void
	{
		_sound.setTransform(transformObject);
	}
	public function get id3():Object
	{
		return _sound.id3;
	}	
}