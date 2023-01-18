/*
 * @author iceeLyne
 * @version 0.5.0
 * @date Mar. 15, 2005
 * Data type extension, dummy, used when explicitly packing number as int(i4) type.
 */
class org.icube.xrf.dataext.Int extends Number {
	//constructor, convert Number to Int.
	public function Int(n:Number) {
		super(Math.round(n));
	}
}
