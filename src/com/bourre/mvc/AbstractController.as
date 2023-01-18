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
 * {@code AbstractController} is the base class for {@code Controller} implementation 
 * in MVC (Model View Controller) architecture.
 * 
 * <p>The controller translates interactions with the {@code view} into actions 
 * to be performed by the {@code model}.
 *  
 * <p>The actions performed by the model include activating business processes or 
 * changing the state of the model. Based on the user interactions and the 
 * outcome of the model actions, the controller responds by selecting an appropriate view.
 * 
 * <p>{@code AbstractController} is an abstract class and can't be directly use.
 * 
 * <p>All custom controllers must extends {@code AbstractController} and 
 * implement {@link IController} interface.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.PixlibStringifier;
import com.bourre.mvc.IController;
import com.bourre.mvc.IModel;
import com.bourre.mvc.IView;

class com.bourre.mvc.AbstractController implements IController
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oView:IView;
	private var _oModel:IModel;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Associates passed-in {@code oModel} model with current controller.
	 * 
	 * @param oModel {@link IModel} instance
	 */
	public function setModel(oModel:IModel) : Void
	{
		_oModel = oModel;
	}
	
	/**
	 * Returns controller's associated model.
	 * 
	 * @return {@link IModel} instance 
	 */
	public function getModel() : IModel
	{
		return _oModel;
	}
	
	/**
	 * Associates passed-in {@link IView} with current controller.
	 * 
	 * @param oView {@link IView} instance
	 */
	public function setView(oView:IView) : Void
	{
		_oView = oView;
	}
	
	/**
	 * Returns controller's associated view.
	 * 
	 * @return {@link IView} instance 
	 */
	public function getView() : IView
	{
		return _oView;
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
	
	private function AbstractController()
	{
		//
	}
	
}