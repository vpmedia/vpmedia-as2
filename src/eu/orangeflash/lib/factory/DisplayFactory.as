class eu.orangeflash.lib.factory.DisplayFactory {
	/*
	 * Статический метод создает экземпляры подклассов MovieClip
	 *
	 * @param	className		Function, ссылка на класс.
	 * @param	parent			MovieClip, родитель, в котором создатся наш экземпляр
	 * @param 	depth			Number, глубина, если не задан то береться самая высокая.
	 * @param	params			Array, параметры для конструктора, поставляются ввиде массива
	 * @returns					MovieClip, экземпляр подкласса MovieClip
	 */
	/*
	 * Static method, creates instance of MovieClip subclass
	 *
	 * @param	className		Function, reference to the class.
	 * @param	parent			MovieClip, parent MovieClip(or it's subclass) for instance
	 * @param 	depth			Number, depth, if not assigned getNexthHighestDepth() will be used
	 * @param	params			Array, params for the constuctor
	 * @returns					MovieClip, instance of the MovieClip subclass
	 */
	public static function createDisplayObject(className:Function,parent:MovieClip,depth:Number,params:Array):MovieClip {
		//проверяем задал ли пользователь глубину, если нет, сажаем на самую верхнюю
		//check if user assign value to depth parameter, if not, use getNextHighestDepth() method
		depth = (depth == null)? parent.getNextHighestDepth():depth;
		//создаем мувик
		//create mc
		var result:MovieClip = parent.createEmptyMovieClip("instance"+getTimer()+depth+Math.round(Math.random()*333),depth);
		//изменим цепочку наследования
		//lets change chain of prototypes
		result.__proto__ = className.prototype;
		//вызываем конструктор
		//invoking constructor
		className.apply(result,params);
		
		return result;
	}
}		