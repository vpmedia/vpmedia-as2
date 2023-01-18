/**
 * 用于测试帧频
 * @author Andre Michelle
 */
class net.manaca.util.FPS
{
	private var timeline: MovieClip;
	private var fps: TextField;
	private var frame: Number;
	private var ms: Number;
	
	function FPS( timeline: MovieClip, depth: Number )
	{
		timeline.createTextField( 'fps' , depth , 0 , 0 , 12 , 12 );
		
		fps = TextField( timeline.fps );

		fps.autoSize = 'left';
		fps.background = true;
		fps.backgroundColor = 0x000000;
		fps.border = true;
		fps.borderColor = 0xffff00;
		
		var tf: TextFormat = new TextFormat();
	
		tf.size = 10;
		tf.font = "Courier";
		tf.color = 0xffff00;
		
		fps.setNewTextFormat( tf );
		
		frame = 0;
		ms = getTimer();

		fps.text = "--";
	}
	
	function count(): Void
	{
		if( getTimer() - ms > 1000 )
		{
			fps.text = frame.toString();
			frame = 0;
			ms = getTimer();
		} else ++frame;
	}
}