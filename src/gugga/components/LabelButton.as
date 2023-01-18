import gugga.components.Button;
/**
 * @author ivo
 */
class gugga.components.LabelButton extends Button 
{
	private var Label:TextField; 
	private var mcLabelContainer:MovieClip;
	
	private var mLabelTitle:String;
	public function get LabelTitle():String { return Label.text; }
	public function set LabelTitle(aValue:String):Void { Label.text = aValue; }
	
	public function get LabelTextWidth() : Number { return Label.textWidth; }
	
	private var mLabelInstanceName:String;
	public function get LabelInstanceName():String { return mLabelInstanceName; }
	public function set LabelInstanceName(aValue:String):Void { mLabelInstanceName = aValue; }
	
	private var mLabelContainerInstanceName:String;
	public function get LabelContainerInstanceName():String { return mLabelContainerInstanceName; }
	public function set LabelContainerInstanceName(aValue:String):Void { mLabelContainerInstanceName = aValue; }
	
	
	public function LabelButton() 
	{
		super();
		
		mLabelInstanceName = "Label";
		mLabelContainerInstanceName = "mcLabel";
	}
	
	public function initializeLabel()
	{
		mcLabelContainer = getComponent(mLabelContainerInstanceName);
		Label = getComponentByPath([mLabelContainerInstanceName, mLabelInstanceName]);
	}
}