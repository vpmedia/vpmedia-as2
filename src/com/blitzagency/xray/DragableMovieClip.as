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
import com.blitzagency.xray.Watch;
import com.blitzagency.util.Delegate;
import com.blitzagency.xray.Xray;

/**
 * DragableMovieClip causes the selected movieclip in the treeview to become "dragable" without disrupting/canceling any
 * onPress/onRelease code that might be associated with the clip.
 *
 * Big Thanks to Erik Westra (aka EECOLOR) for this code!!
 *
 * @author Erik Westra (aka EECOLOR) 	eecolor@zonnet.nl
 */
class com.blitzagency.xray.DragableMovieClip extends MovieClip
{
	static private var _instance:DragableMovieClip;

	private var ___onMouseMove:Function;
	private var broadcastMessage:Function;


	private function DragableMovieClip()
	{
	};

	static public function initialize(mc:MovieClip, restriction_obj:Object):Void
	{
		if (!_instance)
		{
			_instance = new DragableMovieClip();
		};

		var arguments_array:Array = arguments.slice(2);
		_instance._enable.apply(_instance, [mc, restriction_obj].concat(arguments_array));
	};

	private function _customOnPress(restriction_obj:Object)
	{
		var arguments_array:Array = arguments.slice(1);

		this.broadcastMessage.apply(this, ["onDragPress", this].concat(arguments_array));
		if (restriction_obj)
		{
			this.startDrag(false, restriction_obj.left, restriction_obj.top, restriction_obj.right, restriction_obj.bottom);
		} else
		{
			this.startDrag();
		};
		this.___onMouseMove = this.onMouseMove;
		this.onMouseMove = updateAfterEvent;
	};

	private function _customOnRelease()
	{
		this.stopDrag();
		Xray.lc_exec.updateHistory(this);
		this.onMouseMove = this.___onMouseMove;
		this.broadcastMessage.apply(this, ["onDragRelease", this].concat(arguments));
	};

	private function _enable(mc:MovieClip, restriction_obj:Object)
	{
		AsBroadcaster.initialize(mc);

		var arguments_array:Array = arguments.slice(2);

		var onPressDelegate:Function = Delegate.create.apply(Delegate, [mc, _customOnPress, restriction_obj].concat(arguments_array));
		var onReleaseDelegate:Function = Delegate.create.apply(Delegate, [mc, _customOnRelease].concat(arguments_array));
		mc.__removeReferenceDelegatePress__ = onPressDelegate;
		mc.__removeReferenceDelegateRelease__ = onReleaseDelegate;
		Watch.createCallBack(mc, "onPress", onPressDelegate);
		Watch.createCallBack(mc, "onRelease", onReleaseDelegate);
		Watch.createCallBack(mc, "onReleaseOutside", onReleaseDelegate);
	};

	static public function remove(mc:MovieClip):Void
	{
		//_global.AdminTool.trace("remove called", mc);
		var onPressDelegate:Function = mc.__removeReferenceDelegatePress__;
		var onReleaseDelegate:Function = mc.__removeReferenceDelegateRelease__;
		if (onPressDelegate && onReleaseDelegate)
		{
			delete mc.__removeReferenceDelegatePress__;
			delete mc.__removeReferenceDelegateRelease__;
			Watch.removeCallBack(mc, "onPress", onPressDelegate);
			Watch.removeCallBack(mc, "onRelease", onReleaseDelegate);
			Watch.removeCallBack(mc, "onReleaseOutside", onReleaseDelegate);
		};
	};
};