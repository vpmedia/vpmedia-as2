/**
 * @author loop
 */
class ch.sfug.utils.array.ArrayShuffle {

	/**
	 * shuffels the elements of the array
	 */
	public static function shuffle(a:Array):Array {
		a = a.slice();
		var num:Number = Math.round(5+Math.random()*5);
		for (var i:Number=num; i >= 0; i--) {
			var cut:Number = Math.floor(Math.random()*a.length);
			var p0:Array = a.slice(0,cut);
			var p1:Array = a.slice(cut);
			p0.reverse();
			a = p1.concat(p0);
		}
		return a;

	}

}