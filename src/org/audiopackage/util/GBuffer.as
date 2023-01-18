import org.audiopackage.sound.ISoundSource;
/*
* class GBuffer
* Kind of workaround to avoid crashing flash
* It stores a reference of its own instance with
* a reference of a BasicSound Instance to get the onSoundComplete
* Event intact even when the instance is created local
*/

class org.audiopackage.util.GBuffer
{
	static var instances: Array = new Array();
	static var count: Number = 0;
	
	static function clear( gBuffer: GBuffer )
	{
		delete instances[ gBuffer.id ];
	}
	
	private var buffer: ISoundSource;
	private var id: Number;
	
	function GBuffer( ISoundSource: ISoundSource )
	{
		buffer = ISoundSource;
		
		instances[id = count++] = this;
	}
}