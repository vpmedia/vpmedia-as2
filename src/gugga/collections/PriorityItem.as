class gugga.collections.PriorityItem 
{
	private var mID:String;
	public function get ID():String{ return mID; }
	public function set ID(value:String) { mID = value; }
	
	private var mAdditionalData:Object;
	public function get AdditionalData():Object{ return mAdditionalData; }
	public function set AdditionalData(value:Object){ mAdditionalData = value; }
	
	private var mPriority:Number;
	public function get Priority():Number{ return mPriority; }
	public function set Priority(value:Number) { mPriority = value; }	
	
	public function PriorityItem(aID:String, aAdditionalData:Object, aPriority:Number)
	{
		mID = aID;
		mAdditionalData = aAdditionalData;
		mPriority = aPriority;
	}
}