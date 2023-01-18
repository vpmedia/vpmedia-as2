/**
 * 影片剪辑扩展
 * @author Wersling
 * @version 1.0, 2005-9-1
 */
class net.manaca.util.MovieClipUtil
{
	/**
	 * 彻底删除
	 * @param mcClip 需要删除的MovieClip
	 */
	public static function remove(mcClip : MovieClip) : Void 
	{
		mcClip.removeMovieClip ();
		mcClip.onUnload();
		if (mcClip != undefined)
		{
			var mcTemp : MovieClip = mcClip._parent.getInstanceAtDepth (0);
			mcClip.swapDepths (0);
			mcClip.removeMovieClip ();
			if (mcTemp != undefined)
			{
				mcTemp.swapDepths (0);
			}
		}
	}
	/**
	 * 深度复制
	 * @param mcClip	复制源
	 * @param sName	新MC名称
	 * @param nDepth	新MC深度
	 * @param oInit	填充重制影片剪辑的属性的对象
	 * @param bDuplicateProperties		填充重制影片剪辑的属性开关
	 */
	public static function duplicate (mcClip : MovieClip, sName : Object, nDepth : Object, oInit : Object, bDuplicateProperties : Boolean) : MovieClip {
		if (nDepth == true){
			nDepth = mcClip._parent.getNextHighestDepth ();
		}
		if (sName == true){
			sName = mcClip._name + String (nDepth);
		}
		if (oInit == undefined || oInit == null){
			oInit = new Object ();
		}
		if (bDuplicateProperties){
			for (var sItem : String in mcClip){
				oInit [sItem] = mcClip [sItem];
			}
		}
		return mcClip.duplicateMovieClip (String (sName) , Number (nDepth) , oInit);
	}
	
	/** 判断MC是否与鼠标重叠 */
	public static function mouseSuperpose(mcClip:MovieClip):Boolean
	{
		return mcClip.hitTest(_root._xmouse,_root._ymouse,true);
	}
		/** 判断MC是否与鼠标重叠 */
	public static function mouseSuperposeForT (mcClip:MovieClip,parentMc:MovieClip):Boolean
	{
		return mcClip.hitTest(_root._xmouse,_root._ymouse,true);
	}
}
