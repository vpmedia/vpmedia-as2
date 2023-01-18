import mx.utils.Delegate;

import com.jxl.shuriken.controls.Button;

class com.jxl.shuriken.controls.LinkButton extends Button
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.LinkButton";
	
	public function LinkButton()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__mcLabel != null)
		{
			__mcLabel.autoSize = "left";
			var fmt:TextFormat = __mcLabel.getTextFormat();
			fmt.align = TextField.ALIGN_LEFT;
			fmt.color = 0x000080;
			fmt.bold = true;
			fmt.underline = true;
			__mcLabel.setTextFormat(fmt);
			__mcLabel.setNewTextFormat(fmt);
		}
	}
	
	// HACK: does not dispatch size event; if needed, fix here
	// don't want SimpleButton's background, so overwriting here
	private function drawButton():Void{}
	
	public function setColor(val:Number):Void
	{
		var fmt:TextFormat = __mcLabel.getTextFormat();
		fmt.color = val;
		__mcLabel.setTextFormat(fmt);
		__mcLabel.setNewTextFormat(fmt);
	}
	
	public function autoSetSize():Void
	{
		setSize(textField.textWidth + 4, textField.textHeight + 4);
	}
	
}