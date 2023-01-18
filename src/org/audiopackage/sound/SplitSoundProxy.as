import org.audiopackage.sound.*;

class org.audiopackage.sound.SplitSoundProxy
{
	private var sound: SplitSound;
	private var channel: Number;
	
	function SplitSoundProxy( sound: SplitSound, channel: Number )
	{
		this.sound = sound;
		this.channel = channel;
	}
	
	function setVolume( vol: Number ): Void
	{
		sound.setVolume( vol , channel );
	}
	
	function getVolume( Void ): Number
	{
		return sound.getVolume( channel );
	}
	
	function setPan( pan: Number ): Void
	{
		sound.setPan( pan , channel );
	}
	
	function getPan( Void ): Number
	{
		return sound.getPan( channel );
	}
}