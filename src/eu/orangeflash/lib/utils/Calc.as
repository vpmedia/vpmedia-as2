/**
 * Класс eu.orangeflash.lib.calc.Calc, был написан после прочтения книги ActionScript Cookbook, большая часть методов
 * просто портированна из прототипов в AS2 класс.
 * 
 * @author  Nirth
 * @version 1.0
 * @see     Math	
 */
class eu.orangeflash.lib.utils.Calc
{
	/**
	 * Конвертирует градусы в радианы 
	 * 
	 * @usage   		Calc.degToRad(45);
	 * @param   deg 	Number, значение в градусах
	 * @return  		Number, значение в радианах
	 */
	public static function degToRad (deg : Number) : Number
	{
		return (Math.PI * deg) / 180;
	}
	
	/**
	 * Конвертирует радианы в градусы
	 * 
	 * @usage   		Calc.radToDeg(2);
	 * @param   rad     Number, значение в радианах
	 * @return  		Number, значение в градусах
	 */
	public static function radToDeg (rad : Number) : Number
	{
		return (rad * 180) / Math.PI;
	}
	//distance
	/**
	 * Возвращает растояние между двумя точками
	 * 
	 * @usage   			Calc.getDistance(2,2,10,10);
	 * @param   x0 			Number, x координата первой точки
	 * @param   y0 			Number, y координата первой точки
	 * @param   x1 			Number, x координата второй точки
	 * @param   y1 			Number, y координата второй точки
	 * @return  			Number, растояние между точками.
	 */
	public static function getDistance (x0 : Number, y0 : Number, x1 : Number, y1 : Number) : Number
	{
		// Calculate the lengths of the legs of the right triangle.
		var dx : Number = x1 - x0;
		var dy : Number = y1 - y0;
		// Piphagor
		var sqr : Number = Math.pow (dx, 2) + Math.pow (dy, 2);
		return (Math.sqrt (sqr));
	}
	
	/**
	 * Возвращает максимальное значение, в отличии от Math.max() принимает любое кол во значений
	 * 
	 * @usage 				Calc.max(1,2,3,4,5,6,7);  
	 * @return  			Number, наибольший из параметров
	 */
	public static function max () : Number
	{
		var length:Number = arguments.length;
		var max:Number = arguments [0];
		for (var i = 0; i < length; i ++)
		{
			max = Math.max (max, arguments [i]);
		}
		return max;
	}
	
	/**
	 * Возвращает минимальное значение, в отличии от Math.ьшт() принимает любое кол во значений
	 * 
	 * @usage   			Calc.min(1,2,3,4,5,6,7); 
	 * @return  			Number, наименьший из параметров
	 */
	public static function min () : Number
	{
		var length : Number = arguments.length;
		var min : Number = arguments [0];
		for (var i = 0; i < length; i ++)
		{
			min = Math.min (min, arguments [i]);
		}
		return min;
	}
	//round to
	/**
	 * Округляет число, до указанного в параметре decPl разряда
	 * 
	 * @usage   			Calc.
	 * @param   num   
	 * @param   decPl 
	 * @return  
	 */
	public static function round (num : Number, decPl : Number) : Number
	{
		// check DecPl
		if (decPl == undefined)
		{
			return Math.round (num);
		}
		//calculating
		var multiplier : Number = Math.pow (10, decPl);
		return Math.round (num * multiplier) / multiplier;
	}
	public static function floor (num : Number, decPl : Number) : Number
	{
		if (decPl == undefined) return Math.floor (num);
		var multiplier : Number = Math.pow (10, decPl);
		return Math.floor (num * multiplier) / multiplier;
	}
	public static function ceil (num : Number, decPl : Number) : Number
	{
		if (decPl == undefined) return Math.ceil (num);
		var multiplier : Number = Math.pow (10, decPl);
		return Math.ceil (num * multiplier) / multiplier;
	}
	//random from/to
	public static function random (min : Number, max : Number) : Number
	{
		//default
		if (max == undefined)
		{
			return Math.random () * min;
		} else
		{
			return (Math.random () * (max - min)) + min
		}
	}
}
