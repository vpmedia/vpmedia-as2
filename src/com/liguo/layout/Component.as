

/**
 * Interface qui repr�sente un composant dans le package com.liguo.layout
 */
import com.liguo.layout.*;

interface com.liguo.layout.Component {	
				
			
        /**
	 *R�actualise l'affichage du composant
	 */
	public function draw () : Void;
		
			
	/**
	 *Lib�re les ressources du composant
	 */
	public function invalidate () : Void;
		
	
	/**
	 *@return une r�f�rence au MovieClip du composant
	 */
	public function getMC () : MovieClip;
		
				
	/**
	 *D�place le composant � l'int�rieur de son parent de fa�on absolu
	 *@param x:Number coordonn� horizontal
	 *@param y:Number coordonn� vertical
	 */
	public function moveTo (x:Number, y:Number) : Void;
	
	
	/**
	 *D�place le composant � l'int�rieur de son parent de fa�on relative
	 *@param x:Number coordonn� horizontal
	 *@param y:Number coordonn� vertical
	 */
	public function moveBy (x:Number, y:Number) : Void;
	
	

	/**
	 *Redimensionne le composant � une dimension sp�cifique
	 *@param w:Number La largeur
	 *@param h:Number La hauteur
	 */	
	public function resizeTo (w:Number, h:Number) : Void;
	
	
	/**
	 *Redimensionne le composant de fa�on relative
	 *@param w:Number La largeur
	 *@param h:Number La hauteur
	 */	
	public function resizeBy (w:Number, h:Number) : Void;
	
	
	/**
	 * Assigne le parent (Container) du composant
	 *@param c:Container Le container	 
	 */	
	public function setContainer (c:Container) : Void;
	
	
	/**
	 *Retourne une r�f�rence au parent (Container)
	 *@return The container	 
	 */	
	public function getContainer () : Container;	
		
			
	/**
	 *Assigne la largeur du composant
	 *pour obtenir un changement au niveau de l'affichage, il faut invoquer la m�thode draw()
	 *@param w:Number La largeur
	 */	
	public function setWidth (w:Number) : Void;
	
	
	/**
	 *Assigne la hauteur du composant
	 *pour obtenir un changement au niveau de l'affichage, il faut invoquer la m�thode draw()
	 *@param h:Number La hauteur
	 */	
	public function setHeight (h:Number) : Void;
	 
	 
	 
	/**	
	 *@return La largeur du composant
	 */	
	public function getWidth () : Number;
	
	
	/**	
	 *@return La hauteur du composant
	 */		
	public function getHeight () : Number;
	
	
	/**
	 * Assigne la largeur pr�f�r� du composant
	 *@param w:Number la largeur pr�f�r�
	 */	
	public function setPreferredWidth (w:Number) : Void;
	
	
	/**
	 * Assigne la hauteur pr�f�r� du composant
	 *@param h:Number la hauteur pr�f�r�
	 */	
	public function setPreferredHeight (h:Number) : Void;
	
	
	/**	
	 *@return la largeur pr�f�r� du composant
	 */	
	public function getPreferredWidth () : Number;
	
	
	/**	
	 *@return la hauteur pr�f�r� du composant
	 */	
	public function getPreferredHeight () : Number;
		

	/**
	 * Assigne la marge du composant pour tous les c�t�s (top,rigth,bottom,left)
	 *@param nb:Number Le marge
	 */
	public function setMargin (nb:Number) : Void;


	/**
	 * Assigne la marge de droite
	 *@param nb:Number la marge de droite
	 */
	public function setMarginRight (nb:Number) : Void;
	
	
	/**
	 * Assigne la marge de gauche
	 *@param nb:Number la marge de gauche
	 */
	public function setMarginLeft (nb:Number) : Void;
	
	
	/**
	 * Assigne la marge du haut
	 *@param nb:Number la marge du haut
	 */
	public function setMarginTop (nb:Number) : Void;
	
	
	/**
	 * Assigne la marge du bas
	 *@param nb:Number la marge du bas
	 */
	public function setMarginBottom (nb:Number) : Void;
	

	/**	
	 *@return la marge de droite du composant
	 */		
	public function getMarginRight () : Number;
	
		
	/**	
	 *@return la marge de gauche du composant
	 */	
	public function getMarginLeft () : Number;
	
	
	/**	
	 *@return la marge du haut du composant
	 */	
	public function getMarginTop () : Number;
	
	
	/**	
	 *@return la marge du bas du composant
	 */	
	public function getMarginBottom () : Number;

}
