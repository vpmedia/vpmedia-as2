class janumedia.components.poll_result_bar extends MovieClip {
	var left, right, center, bar_center, bar_right:MovieClip;
	var value_txt, presentage_txt:TextField;
	var __vote, __totaluser:Number;
	function poll_result_bar() {
		_global.tt("generate bar result");
		value_txt.autoSize = true;
		Stage.addListener(this);
		//onResize();
	}
	function onResize() {
		setSize(this._parent.bg.width, this._height);
	}
	function setSize(w, h) {
		center._width = w-this._x-left._width-right._width-presentage_txt._width-6;
		right._x = center._x+center._width;
		presentage_txt._x = right._x+right._width;
		update();
	}
	function update() {
		value_txt.text = __vote == undefined ? 0 : __vote;
		presentage_txt.text = __vote == 0 || __vote == undefined ? 0+"%" : ((__vote/__totaluser)*100)+"%";
		//var a = center._width + right._width - 1.8;
		bar_center._width = center._width*__vote/__totaluser;
		bar_right._x = bar_center._x+bar_center._width;
	}
	function set vote(n:Number):Void {
		__vote = n;
	}
	function set totaluser(n:Number):Void {
		__totaluser = n;
		update();
	}
	function get vote():Number {
		return __vote;
	}
	function get totaluser():Number {
		return __totaluser;
	}
}
