/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import mx.events.EventDispatcher;

class com.blitzagency.util.PointConverter
{
	/**  Author: John Grden
	* Returns a point object to determine the _x and _y positions of
	* a specified MovieClip relative to another.
	*
	* @param from MovieClip the movie clip that you want to map or place.
	* @param to MovieClip the movie clip who's coordinates you want to match
	*/

	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	public static var _instance:PointConverter = null;

	public static function getInstance():PointConverter
	{
		if(PointConverter._instance == null)
		{
			PointConverter._instance = new PointConverter();
		}
		return PointConverter._instance;
	}

	private function PointConverter()
	{
		// initialize event dispatcher
		EventDispatcher.initialize(this);

		// setup global
		_global.localToLocal = function() { PointConverter.localToLocal.apply(PointConverter, arguments) };
	}

	public static function localToLocal(from:MovieClip, to:MovieClip):Object
	{
		var point:Object = {x: 0, y: 0};
		from.localToGlobal(point);
		to.globalToLocal(point);
		return point;
	}
}