
/**
 * SoundPlus: This example shows how simple it can be to create a separate class with 
 * tweenable getter/setter properties as an alternative to FuseFX.
 * 
 * @author  Moses Gunesch
 * @version 1.0
 */
 
 class com.mosesSupposes.tweentargets.SoundPlus extends Sound {
	
	function SoundPlus(target : Object) {
		super(target);
	}
	
	function get volume():Number {
		return this.getVolume();
	}
	
	function set volume(v:Number) {
		this.setVolume(v);
	}
	
	function get pan():Number {
		return this.getPan();
	}
	
	function set pan(v:Number) {
		this.setPan(v);
	}
}