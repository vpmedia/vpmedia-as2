import org.audiopackage.sound.ISoundSource;

interface org.audiopackage.sound.ISoundListener
{
	function onStart( sound: ISoundSource, delay: Number ): Void;
}