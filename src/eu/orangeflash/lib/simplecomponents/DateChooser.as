import eu.orangeflash.lib.events.EDispatcher;
import eu.orangeflash.lib.factory.DisplayFactory;
import eu.orangeflash.lib.utils.DateUtils;
import eu.orangeflash.lib.simplecomponents.DateChooserDefaultCell;
import eu.orangeflash.lib.simplecomponents.IDateChooserCell;
/**
 * Simple callendar component
 * 
 * @author  Nirth
 * @version 1.0
 * @see     EDispatcher	
 * @since   
 */
class eu.orangeflash.lib.simplecomponents.DateChooser extends EDispatcher {
	public static var MONTHS:Array = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"];
	//
	private var date:Date;
	private var container:MovieClip;
	private var fields:Array;
	private var dates:Array;
	private var currentMonth:Number;
	private var currentYear:Number;
	private var currentDay:Number;
	private var defaultTextFormat:TextFormat;
	private var cellRenderer:Function = eu.orangeflash.lib.simplecomponents.DateChooserDefaultCell;
	public function DateChooser(cellClass:Function) {
		var date:Date = new Date();
		currentMonth = date.getMonth();
		currentYear = date.getFullYear();
		currentDay = date.getDate();
		trace("day is:"+currentDay);
		//
		if (cellClass != undefined) {
			cellRenderer = cellClass;
		}
		drawChooser(currentYear, currentMonth);
	}
	/**
	 * Sets month value to next month
	 * 
	 * @usage   		myDateChooser.nextMonth();
	 * @return  		Nothing;
	 */
	public function nextMonth():Void {
		month++;
	}
	/**
	 * Sets month value to previous month
	 * 
	 * @usage   		myDateChooser.prevMonth();
	 * @return  		Nothing;
	 */
	public function prevMonth():Void {
		month--;
	}
	/**
	 * Property[Read-Write], indicates current month, where 0 is January and 11 is December
	 * 
	 * @usage   			myDateChooser.month++;
	 * @param   val 		Number, index of month
	 * @return  			Number, current index of month
	 */
	public function set month(val:Number):Void {
		currentMonth = val;
		if (currentMonth>11) {
			currentMonth = 0;
			currentYear++;
		} else if (currentMonth<0) {
			currentMonth = 11;
			currentYear--;
		}
		drawChooser();
		dispatchEvent({type:'changed',target:this});
	}
	public function get month():Number {
		return currentMonth;
	}
	/**
	* 
	* @return
	*/
	public function set year(val:Number):Void {
		currentYear = val;
		drawChooser();
		dispatchEvent({type:'changed',target:this});
	}
	public function get year():Number
	{
		return currentYear;
	}
	/**
	* 
	* @return
	*/
	public function get monthString():String {
		return MONTHS[currentMonth];
	}
	/**
	* 
	* @return
	*/
	public function get buttons():Array
	{
		return fields;
	}
	/**
	 * Property[Read-Only],returns month name and year
	 * 
	 * @usage   	myDateChooser.monthString
	 * @return  	String, month name and year
	 */
	public function get fullDate():String {
		return MONTHS[currentMonth]+" "+currentYear;
	}
	//===============
	//private methods
	//===============
	private function buildField():Void {
		container.removeMovieClip();
		container = createEmptyMovieClip("container", 1);
		fields = new Array();
		var d:Number = 0;
		var month:Number = new Date().getMonth();
		var year:Number = new Date().getFullYear();
		var day:Number = new Date().getDate();
		for (var j:Number = 0; j<6; j++) {
			for (var i:Number = 0; i<7; i++) {
				if(dates[d] != undefined) {
					var width:Number = cellRenderer.WIDTH;
					var height:Number = cellRenderer.HEIGHT;
					var x:Number = width*i;
					var y:Number = height*j;
					var cell:IDateChooserCell = IDateChooserCell(DisplayFactory.createDisplayObject(cellRenderer, container, d, [x, y, this, d]));
					fields.push(cell);
					cell.setDate(dates[d]);
					if(month == currentMonth && year == currentYear && fields.length == day)
					{
						cell.highLight();
					}					
				}
				d++;
			}
		}
	}
	private function monthDates(year:Number, month:Number):Void {
		var begin:Number = DateUtils.getFirstDayOfMonth(year, month)-1;
		if(begin == -1) {
			begin = 6;
		}
		var end:Number = begin+DateUtils.getDaysInMonth(year, month);
		dates = Array(42);
		for (var i:Number = begin; i<end; i++) {
			var date:Number = i-begin+1;
			dates[i] = date;
		}
	}
	private function drawChooser():Void {
		monthDates(currentYear, currentMonth);
		buildField();
	}
}
