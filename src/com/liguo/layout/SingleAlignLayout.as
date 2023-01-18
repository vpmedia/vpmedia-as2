

/**
 *Le SingleAlignLayout est comme le FlowLayout mais pour UN seul composant.
 *L'algorithme de positionnement est beaucoup plus simple et léger que le FlowLayout  
 * 
 * usage :  myContainer.setLayout(SingleAlignLayout.LEFT_MIDDLE);
 */

import com.liguo.layout.*;

class com.liguo.layout.SingleAlignLayout implements Layout {

	public static var className:String = "SingleAlignLayout";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.1.0";
	public static var author:String = "liguorien";
	public static var link:String = "http://www.liguorien.com";


	public static var LEFT_TOP:SingleAlignLayout = new SingleAlignLayout(Align.LEFT, Align.TOP);
	public static var LEFT_MIDDLE:SingleAlignLayout = new SingleAlignLayout(Align.LEFT, Align.MIDDLE);
	public static var LEFT_BOTTOM:SingleAlignLayout = new SingleAlignLayout(Align.LEFT, Align.BOTTOM);
	public static var CENTER_TOP:SingleAlignLayout = new SingleAlignLayout(Align.CENTER, Align.TOP);
	public static var CENTER_MIDDLE:SingleAlignLayout = new SingleAlignLayout(Align.CENTER, Align.MIDDLE);
	public static var CENTER_BOTTOM:SingleAlignLayout = new SingleAlignLayout(Align.CENTER, Align.BOTTOM);
	public static var RIGHT_TOP:SingleAlignLayout = new SingleAlignLayout(Align.RIGHT, Align.TOP);
	public static var RIGHT_MIDDLE:SingleAlignLayout = new SingleAlignLayout(Align.RIGHT, Align.MIDDLE);
	public static var RIGHT_BOTTOM:SingleAlignLayout = new SingleAlignLayout(Align.RIGHT, Align.BOTTOM);
	

	public var align:Align;
	public var valign:Align;

	private function SingleAlignLayout (a:Align, v:Align) {		
		align = a;
		valign = v;				
	}

	/**
	 *Réactualise la position et la taille des enfants d'un container
	 *cette méthode est invoqué par le container en question
	 *@param c:Container Le container
	 */
	public function doLayout (c:Container) : Void {
		
		var comp:Component = c.getComponentAt(0);
		
		comp.draw();
		
		var internalWidth:Number = c.getWidth() - c.getPaddingLeft() - c.getPaddingRight();		
		var availableWidth:Number = internalWidth - (comp.getPreferredWidth() + comp.getMarginLeft() + comp.getMarginRight());
	
		var internalHeight:Number = c.getHeight() - c.getPaddingTop() - c.getPaddingBottom();		
		var availableHeight:Number = internalHeight - (comp.getPreferredHeight() + comp.getMarginTop() + comp.getMarginBottom());
	
		
		comp.moveTo(align.getPosition(availableWidth), valign.getPosition(availableHeight));
	}
	
	
	/**
	 *Invoqué par le Container lorsque le layout lui est assigné
	 *@param c:Container Le container
	 */
	public function onSetLayout (c:Container) : Void {
		
	}
	
	
	/**
	 *Invoqué par le Container lorsque le layout ne lui est plus assigné
	 *@param c:Container Le container
	 */
	public function onRemoveLayout (c:Container) : Void {
		
	}
}

