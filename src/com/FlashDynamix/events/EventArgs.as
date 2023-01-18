class com.FlashDynamix.events.EventArgs {
	//
	private var _owner;
	private var _value:Object;
	private var _type:String;
	private var _control:MovieClip;
	//
	public function EventArgs(o, t, v, c) {
		owner = o;
		type = t;
		value = v;
		control = c;
	}
	public function get owner() {
		return _owner;
	}
	public function set owner(o) {
		_owner = o;
	}
	public function get value() {
		return _value;
	}
	public function set value(v) {
		_value= v;
	}
	public function get type() {
		return _type;
	}
	public function set type(t) {
		_type = t;
	}
	public function get control() {
		return _control;
	}
	public function set control(c) {
		_control = c;
	}
}
