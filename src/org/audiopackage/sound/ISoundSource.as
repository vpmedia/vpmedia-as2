import org.audiopackage.sound.ISoundListener;

interface org.audiopackage.sound.ISoundSource
{
	function attachSound( linkageId: String ): ISoundSource;
	function start(): Boolean;
	function stop( Void ): Void;
	function setVolume( value: Number ): Void;
	function getVolume( Void ): Number;
	function setPan( value: Number ): Void;
	function getPan( Void ): Number;
	function isBusy( Void ): Boolean;
	function getTargetClip( Void ): MovieClip;
	function getLinkageId( Void ): String;
	
	function clone( targetClip: MovieClip ): ISoundSource;
	
	function addListener( listener: ISoundListener ): Void;
	function removeListener( listener: ISoundListener ): Boolean;
}