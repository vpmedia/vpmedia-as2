/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code AbstractView} is the base class for {@code View} implementation 
 * in MVC (Model View Controller) architecture.
 * 
 * <p>The {@code view} renders the contents of a {@code model}.
 * It accesses enterprise data through the model and specifies how that data should be presented. 
 * 
 * <p>It is the view's responsibility to maintain consistency in its presentation when the model changes. 
 * 
 * <p>{@code AbstractView} is an abstract class and can't be directly use.
 * 
 * <p>All custom views must extends {@code AbstractView} and 
 * implement {@link IView} interface.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.PixlibStringifier;
import com.bourre.mvc.AbstractModel;
import com.bourre.mvc.IController;
import com.bourre.mvc.IModel;
import com.bourre.mvc.IView;

class com.bourre.mvc.AbstractView implements IView
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oController:IController;
	private var _mcContainer:MovieClip;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Registers passed-in {@code oModel} model with current view.
	 * 
	 * @param oModel an {@link IModel} instance
	 */
	public function registerWithModel( oModel:IModel ) : Void
	{
		AbstractModel( oModel ).addModelListener(this);
	}
	
	/**
	 * Returns {@link IController} associated with this view.
	 * 
	 * @return {@link IController} instance
	 */
	public function getController() : IController
	{
		return _oController;
	}
	
	/**
	 * Associates passed-in {@link IController} controller with this view.
	 * 
	 * @param oController a {@link IController} instance
	 */
	public function setController(oController:IController) : Void
	{
		_oController = oController;
	}
	
	/**
	 * Registers passed-in {@code oModel} with current view.
	 * 
	 * @param oModel {@link IModel} instance
	 */
	public function setModel(oModel:IModel) : Void
	{
		registerWithModel( oModel );
	}
	
	/**
	 * Defines passed-in {@code mcContainer} {@code MovieClip} as 
	 * visual container.
	 * 
	 * @param mcContainer {@code MovieClip} instance (default : _root)
	 */
	public function setViewContainer(mcContainer:MovieClip) : Void
	{
		_mcContainer = mcContainer? mcContainer : _root;
	}
	
	/**
	 * Returns visual container for current view.
	 * 
	 * @return {@code MovieClip} instance
	 */
	public function getViewContainer() : MovieClip
	{
		return _mcContainer;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function AbstractView(oModel:IModel, oController:IController, mcContainer:MovieClip)
	{
		setModel(oModel);
		setController(oController);
		setViewContainer(mcContainer);
	}
	
}