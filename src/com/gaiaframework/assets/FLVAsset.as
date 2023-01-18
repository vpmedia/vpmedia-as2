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

class com.gaiaframework.assets.FLVAsset extends AbstractAsset
{
	private var _ns:NetStream;
	private var _nc:NetConnection;
	
	function FLVAsset()
	{
		super();
	}
	public function get ns():NetStream
	{
		return _ns;
	}
	public function init():Void
	{
		isActive = true;
		_nc = new NetConnection();
		_nc.connect(null);
		_ns = new NetStream(_nc);
	}
	public function preload():Void
	{
		_ns.play(src);
		_ns.pause(true);
		super.load();
	}
	public function load():Void
	{
		_ns.play(src);
	}
	public function getBytesLoaded():Number
	{
		return _ns.bytesLoaded;
	}
	public function getBytesTotal():Number
	{
		return _ns.bytesTotal;
	}
	public function destroy():Void
	{
		_ns.close();
		_nc.connect(null);
		delete _ns;
		delete _nc;
		super.destroy();
	}
	public function retry():Void
	{
		_ns.play(src);
		_ns.pause(true);
	}
	
	// PROXY FLV PROPS/FUNCS
	public function get bufferLength():Number
	{
		return _ns.bufferLength;
	}
	public function get bufferTime():Number
	{
		return _ns.bufferTime;
	}
	public function get bytesLoaded():Number
	{
		return _ns.bytesLoaded;
	}
	public function get bytesTotal():Number
	{
		return _ns.bytesTotal;
	}
	public function close():Void
	{
		_ns.close();
	}
	public function get currentFps():Number
	{
		return _ns.currentFps;
	}
	public function onMetaData(func:Function):Void
	{
		_ns.onMetaData = func;
	}
	public function onStatus(func:Function):Void
	{
		_ns.onStatus = func;
	}
	public function pause(flag:Boolean):Void
	{
		_ns.pause(flag);
	}
	public function play(start:Number, len:Number):Void
	{
		_ns.play(src, start, len);
	}
	public function seek(offset:Number):Void
	{
		_ns.seek(offset);
	}
	public function setBufferTime(bufferTime:Number):Void
	{
		_ns.setBufferTime(bufferTime);
	}
	public function get time():Number
	{
		return _ns.time;
	}
}