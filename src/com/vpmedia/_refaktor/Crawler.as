class Crawler extends MovieClip {
	private var friction:Number;
	private var speed:Number;
	private var radius:Number;
	private var boundsLeft:Number;
	private var boundsRight:Number;
	private var boundsTop:Number;
	private var boundsBottom:Number;
	private var frames:Number;
	private var count:Number;
	private var _vx:Number;
	private var _vy:Number;
	private var _mx:Number;
	private var _my:Number;
	private function Crawler () {
		friction = 0.95;
		speed = 4;
		radius = 0;
		boundsLeft = 0;
		boundsRight = Stage.width;
		boundsTop = 0;
		boundsBottom = Stage.height;
		frames = 35;
		count = 0;
		_vx = 0;
		_vy = 0;
		_mx = 0;
		_my = 0;
	}
	function onEnterFrame ():Void {
		if (count == frames) {
			_vx = Math.random () * (1 + speed * 2) - speed;
			_vy = Math.random () * (1 + speed * 2) - speed;
			count = 0;
		}
		else {
			_mx = (_mx * friction) + (_vx * (1 - friction));
			_my = (_my * friction) + (_vy * (1 - friction));
			_x += _mx;
			_y += _my;
			count++;
			if (_x < boundsLeft) {
				_x = boundsLeft;
				_mx = -_mx;
			}
			if (_x > boundsRight) {
				_x = boundsRight;
				_mx = -_mx;
			}
			if (_y < boundsTop) {
				_y = boundsTop;
				_my = -_my;
			}
			if (_y > boundsBottom) {
				_y = boundsBottom;
				_my = -_my;
			}
		}
	}
}
