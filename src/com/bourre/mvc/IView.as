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
 * {@code IView} defines basic rules for {@code view} instance 
 * using Pixlib MVC pattern.
 * 
 * <p>All views must extends {@link AbstractView} and 
 * implement {@code IView} interface.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.mvc.IController;
import com.bourre.mvc.IModel;

interface com.bourre.mvc.IView 
{
	/**
	 * Returns {@link IController} associated with this view.
	 * 
	 * @return {@link IController} instance
	 */
	public function getController() : IController;
	
	/**
	 * Associates passed-in {@link IController} controller with this view.
	 * 
	 * @param oController a {@link IController} instance
	 */
	public function setController(oController:IController) : Void;
	
	
	//public function getModel() : IModel;
	
	/**
	 * Registers passed-in {@code oModel} with current view.
	 * 
	 * @param oModel {@link IModel} instance
	 */
	public function setModel(oModel:IModel) : Void;
	
	/**
	 * Defines passed-in {@code mcContainer} {@code MovieClip} as 
	 * visual container.
	 * 
	 * @param mcContainer {@code MovieClip} instance (default : _root)
	 */
	public function setViewContainer(mcContainer:MovieClip) : Void;
	
	/**
	 * Returns visual container for current view.
	 * 
	 * @return {@code MovieClip} instance
	 */
	public function getViewContainer() : MovieClip;
}