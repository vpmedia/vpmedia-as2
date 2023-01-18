import gugga.components.Button;

class gugga.components.LinkButton extends Button
{
	
	private var mLink:String;
	public function get Link():String { return mLink; }
	public function set Link(value:String):Void { mLink = value; }
	
	private var mLinkTarget:String = "_self";
	public function get LinkTarget():String { return mLinkTarget; }
	public function set LinkTarget(value:String):Void { mLinkTarget = value; }
	
	function onRelease()
	{
		super.onRelease();
		
		if (this.Enabled)
		{
			getURL(mLink, mLinkTarget);
		}
	}
	
}
