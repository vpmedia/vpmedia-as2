import com.mosesSupposes.fusefx.IFuseFX;
import com.mosesSupposes.fuse.FuseKitCommon;
import com.mosesSupposes.fuse.ZigoEngine;

/**
 * FuseFX utility
 * Copyright (c) 2007 Moses Gunesch, MosesSupposes.com
 * @ignore
 * 
 * FuseFXProperty: Data object used in registering a new extension property.
 * 
 * @usage
 * You'll use this class in authoring extensions. For more information see {@link com.mosesSupposes.fusefx.IFuseFX}.
 */
 
class com.mosesSupposes.fusefx.FXProperty {
	
	/**
	 * Stores the key passed in the constructor
	 */
	public var key : String;
	/**
	 * Stores the IFuseFX extension class reference passed in the constructor
	 */
	public var fxclass : Function;
	/**
	 * Stores the full conflict string passed in the constructor
	 */
	public var conflicts : String;
	/**
	 * Provides FuseFX speedier access to each conflict string
	 */
	public var conflictLookup : Object;
	
	/**
	 * Defines a single tweenable property string, associates it with an IFuseFX extension, and identifies conflicts with other tweenable properties.
	 * @param FXClass	A reference to the IFuseFX extension class (not an instance, the class itself)
	 * @param key		The tweenable property string being defined
	 * @param conflicts	Null or a comma-delimited string listing any other properties that conflict or overlap with the property being defined.
	 */
	public function FXProperty(FXClass:Function, key:String, conflicts:String) {
		var test:IFuseFX = new FXClass();
		if (!(test instanceof IFuseFX)) {
			FuseKitCommon.output("** FXProperty developer error ('"+key+"'): First argument should be the actual IFuseFX class like TextFX, not an instance of the class. **");
		}
		delete test;
		if (key==null || key.length==0) {
			FuseKitCommon.output("** FXProperty developer error: null key passed. **");
		}
		
		this.fxclass = FXClass;
		this.key = key;
		this.conflicts = conflicts;
		this.conflictLookup = {};
		if (conflicts!=null && conflicts.length>0) {
			var ca:Array = conflicts.split(',');
			for (var i:String in ca) 
				if ( ca[i]!=null ) 
					conflictLookup[ ca[i] ] = true;
		}
	}
	
	/**
	 * Strips conflicting properties defined in the constructor from a target using ZigoEngine.removeTween.
	 * @param target	The tween target to be affected
	 */
	public function removeConflicts(target:Object):Void {
		if (conflicts.length>0) {
			/* (The way this is written resolves a tricky issue where too many rapidfire 
			 * remove calls kill the engine if there's only one tween running in the SWF.) 
			 */
			_global.com.mosesSupposes.fuse.ZigoEngine.instance.removeTween(target, conflicts, true);
		}
	}
}