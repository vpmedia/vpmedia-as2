import pl.milib.core.supers.MIClass;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.data.Averager extends MIClass {
	
	private var history : Array;
	private var sum : Number;
	public var lengthLimit:Number;
	private var average : Number;
	private var isNewAverage : Boolean;
	
	public function Averager($lengthLimit:Number) {
		lengthLimit=$lengthLimit==null ? 15 : $lengthLimit;
		if(lengthLimit<0){ lengthLimit=0; }
		history=[];
		sum=0;
		isNewAverage=true;
		average=1;
	}//<>
	
	public function push(num:Number):Void {
		history.push(num);
		sum+=num;
		while(history.length>lengthLimit){
			sum-=Number(history.shift());
		}
		isNewAverage=false;
	}//<<
	
	public function getAverage(Void):Number {
		if(!isNewAverage){ average=sum/history.length; isNewAverage=true; }
		return average;
	}//<<
	
	public function getAddedRecently(Void):Number {
		return history[history.length-1];
	}//<<
	
}