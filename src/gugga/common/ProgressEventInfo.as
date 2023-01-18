/**
 * @author Barni
 */
class gugga.common.ProgressEventInfo 
{
	public var target : Object;
	public var total : Number;
	public var current : Number;
	public var percents : Number;
	
	private var type : String; 
	
	public function ProgressEventInfo(aTarget : Object, aTotal : Number, 
		aCurrent : Number, aPercents : Number) 
	{
		target = aTarget;
		total = aTotal;
		current = aCurrent;
		percents = aPercents;
		type = "progress";
	}	
}