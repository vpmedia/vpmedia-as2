/**
 * FuseFX utility
 * Copyright (c) 2007 Moses Gunesch, MosesSupposes.com
 * @ignore
 * 
 * Interface to implement when creating extensions for the FuseFX utility.
 * @usage
 * Creating extensions is simple: Define your tween properties, construct 
 * new tweens in <i>addTween</i> or return false if the target is a bad fit, 
 * perform tween actions in the <i>onTweenUpdate</i> event handler (listeners 
 * are automated for you by FuseFX), then perform any final steps and cleanup in 
 * <i>destroy</i>. 
 * <br><br>
 * <b>Approach</b>
 * A primary advantage of FuseFX is that it allows you to choose which target 
 * makes the most intuitive sense to tween on. For example, TextFX works by tweening 
 * directly on a TextField, while actually updating the TextField's associated 
 * TextFormat. This is great for the user because it's incredibly direct. In reality 
 * though, it exploits ActionScript 2.0's loose protections by intrusively 
 * modifying a presumably final class, such as sticking a new public variable 
 * called volumeFX into a Sound object. (Remember that FuseFX extensions decorate, 
 * but do not replace, standard ZigoEngine tweens.)<br>
 * <br>
 * Many systems in AS2.0, even the official EventDispatcher class, write properties 
 * into target objects, but it does bend the rules and presents some risk of harming 
 * a target object, like you could overwrite an internal property of the target class.
 * So when authoring FuseFX extensions, try to remain as non-disruptive and 
 * non-intrusive as possible and of course, don't leave a mess. These examples use 
 * ASSetPropFlags calls to hide these injected properties from for-in loops, then 
 * strip the properties back out of the target on tween completion.
 * <br><br>
 * <b>General rules</b>
 * <ul>
 * 	<li>Do not import Fuse unless absolutely necessary for your extension's effects. 
 * 	You may freely import ZigoEngine and FuseKitCommon, but importing Fuse will add 
 * 	filesize to the end user's swf.</li>
 * 	<li>Unless your extension directly relates to Flash 8 filters or effects, author 
 * 	for Fuse Kit's baseline of Flash Player 6. (Avoid try/catch, setTimeout, etc.)</li>
 * 	<li>If you want to output a message (such as an error) to the user, use the static 
 * 	<code>FuseKitCommon.output</code> method instead of trace. This keeps the Fuse Kit 
 * 	configurable for any logging program.</li>
 * 	<li>Choose your extension's name and property names carefully 
 * 	(see {@link #defineProperties} for details).</li>
 * 	</ul>
 * 	
 * @author  Moses Gunesch
 * @version 0.3
 */
interface com.mosesSupposes.fusefx.IFuseFX {
	
	
	
	/**
	 * Used by FuseFX during register. Associates tweenable property strings to this extension 
	 * and identifies conflicts with other tweenable properties.
	 * 
	 * @usage	
	 * In this hypothetical example an extension called GnarlyFX generates FXProperty instances 
	 * for each new property. The first parameter is the extension class, the second is the 
	 * property string, and the third is a comma-delimited conflicts string.
	 * 
	 * <pre>public static var HUE:String = 'hueFX';
	 * public static var BEZIER:String = 'quadBezierFX';
	 * public static var VOLUME:String = 'volumeFX';
	 * 
	 * public function defineProperties() : Array {
	 * 	var a:Array = [];
	 * 	a.push( new FXProperty(GnarlyFX, HUE, FuseKitCommon.ALLCOLOR) );
	 * 	a.push( new FXProperty(GnarlyFX, BEZIER, '_x,_y') );
	 * 	a.push( new FXProperty(GnarlyFX, VOLUME, null) );
	 * 	return a;
	 * }</pre>
	 * <br>
	 * <b>Tweenable keys</b>
	 * 	<blockquote>
	 * 	<ul>
	 * 	<li><b>We recommend ending keys with "FX"</b> which reminds users of the active extension 
	 * 	and helps avoid the following conflicts:
	 * 		<ol>
	 * 		<li><i>An unrelated property with the same name might exist in the target.</i>
	 * 		</li>
	 * 		<li><i>Conflicts might occur with reserved Fuse Kit properties.</i> For example, both 
	 * 		"_brightness" and "brightness" are reserved, and will always be tweened by ZigoEngine 
	 * 		as Flash-7-Color transforms. (See docs: ZigoEngine.doTween, Fuse constructor)
	 * 		</li>
	 * 		</ol>
	 * </li>
	 * 	<li><b>Tweenable-property keys should simple but must clearly indicate what they do.</b> 
	 * 	A Fuse containing a property called <i>sizeFX</i> would be too vague (size of what?) and 
	 * 	somewhat rudely takes over that property from any other extensions, whereas the string 
	 * 	<i>textSizeFX</i> allows the developer reading the Fuse action to determine that font size 
	 * 	will be affected.
	 * 	</li>
	 * <li><b>Keys should not be standard properties like _x or _y.</b> Instead, define differing 
	 * property names and list _x as a conflict. Your onTweenUpdate handler can then set _x on the 
	 * target. You cannot redefine a property like _x because ZigoEngine locks the tween over time 
	 * to its path, so you can't use onTweenUpdate to move the target to a new position. If you 
	 * truly need an extension to handle pre-existing properties, for instance if you want to extend 
	 * position tweening and still have bezier tweens work, follow the example class Wraparound.
	 * </li>
	 * 	<li><b>Each property may have an accompanying 'constant'</b>: a public static variable 
	 * 	that defines the  tweenable string. These do <b>not</b> define the extension's keys though. 
	 * 	They are simply an optional convenience for the user. The real keys are the strings the 
	 * 	constants point to, and are set in the FXProperty instances. Constants can be simple, 
	 * 	since they are directly associated with an extension class whose name is also descriptive. 
	 * 	</li>
	 * </ul>
	 * </blockquote>
	 * 
	 * <b>Conflicts</b>
	 * <ul>
	 * <li>
	 * Tween engines must avoid "overlapping" tweens, that is two tween properties that try to affect the same
	 * change on a target at once.
	 * </li>
	 * <li>
	 * In authoring a tweening extension, it is extremely important that you carefully identify where such conflicts 
	 * might arise. For example, a Flash 8 or higher ColorTransform should pass the constant FuseKitCommon.ALLCOLOR  
	 * for the conflict string, so the engine will stop processing any regular color-transforms. A Matrix-based  
	 * extension that positions a clip using translation should set conflicts to "_x,_y". Don't rush this step. 
	 * Your product needs to meet the expectations of the Kit.
	 * </li>
	 * <li>
	 * FuseFX uses the conflict data you provide to automate two processes: First, it removes conflicting tweens 
	 * from the target when an extension is successfully instantiated. Second, it monitors <i>all</i> tweens added 
	 * to the engine and kills active extension tweens when the user tweens a conflicting property.
	 * </li>
	 * </ul>
	 * 
	 * @return	An Array of FXProperty instances.
	 * @see com.mosesSupposes.fusefx.FXProperty
	 */
	public function defineProperties() : Array;
	
	
	
	
	
	
	/**
	 * Setup, called just prior to tweening. Do NOT use addListener(this) on the target.
	 * 
	 * @usage
	 * MANDATORY: Return true or false based on whether the extension should be activated 
	 * or immediately deleted, for instance if the target is the wrong type. (Use 
	 * <code>FuseKitCommon.output</code> to throw any related error messages.)
	 * <br><br>
	 * MANDATORY: Tween property MUST exist or be written into the target and MUST be set 
	 * to the datatype being tweened, such as a valid number (or in some cases an object or array).
	 * <br><br>
	 * Storing the property being tweened is necessary for any extension with more than one 
	 * property. It is not necessary to store a hard reference to the target object, since
	 * all interface methods receive a temporary reference to the target in their arguments.
	 * <br><br>
	 * Tween end-value is passed for special cases like type-checking, normally you may ignore it.
	 * <br><br>
	 * Other events: You may also choose to add an <code>onTweenStart</code> event handler to your 
	 * extension class, again you do not need to add a listener. Whereas <code>addTween</code> 
	 * is called just prior to a tween being added to the engine, the <code>onTweenStart</code> event 
	 * is fired as animation begins, after any delay passed by the user. However do <b>not</b> use an 
	 * <code>onTweenEnd</code> event, use {@link #destroy} for final actions, because FuseFX uses 
	 * onTweenEnd to destroy extension instances.
	 * <br><br>
	 * You do not need to worry about removing conflicting tween properties on the target; this is 
	 * automated based on the information you provide in <code>defineProperties</code>.
	 * 
	 * @param target	The tween target object (not necessary to store a hard reference!)
	 * @param prop		The tween property which has been pre-verified as one of this extension's keys.
	 * @param endval	The tween end-value passed by the user (for special cases like type checking)
	 */
	public function addTween(target:Object, prop:String, endval:Object) : Boolean;
	
	
	
	
	
	
	/**
	 * Perform tween updates. Do NOT add a listener to the target, FuseFX does this for you.
	 * @usage Do NOT add a listener to the target, FuseFX does this for you.
	 * @param o		Event object sent by engine containing {target:Object, props:Array}
	 */
	public function onTweenUpdate(o:Object) : Void;
	
	
	
	
	
	/**
	 * Cleanup, called just prior to deletion. Listeners are automatically removed by FuseFX.
	 * 
	 * @usage
	 * Do not delete or remove the target object during destroy! You are only cleaning up this instance.
	 * <br><br>
	 * Delete any external object references and remove any additional listeners you may have manually 
	 * added during the extension's lifespan. (Again, do NOT add a listener to the target for 
	 * onTweenUpdate, FuseFX does this for you.) 
	 * <br><br>
	 * If the property was written into the target in addTween and the user doesn't expect it to 
	 * be a persistent property, it is good practice to delete it from the target here.
	 * (In some cases it may be difficult to recreate the final setting on a next tween, 
	 * in which case you could leave it, then only overwrite it in addTween if it doesn't exist.)
	 * 
	 * @param target	The original tween target, which may be missing. Passed in the three primary methods  
	 * 					so you can avoid storing a hard reference to tween targets.
	 */
	public function destroy(target:Object) : Void;
}



