/********
* Copyright (c) 2005 Josh Tynjala.
* All rights reserved.
* Source code usage and redistribution governed by a BSD style license
* http://lab.zeusdesign.net/index.php/source-code-licensing/
********/

import mx.effects.Tween;

class net.zeusdesign.RetroCredits
	extends MovieClip
{
	//*** MEMBER VARIABLES ***//
	public var text:Array;
	public var __width:Number;
	public var __height:Number;
	
	//timing
	public var shapeUpdateTime:Number;
	public var textFadeInTime:Number;
	public var textFadeOutTime:Number;
	public var loop:Boolean;
	
	//styling
	public var shapeColors:Array;
	public var primaryTextFormat:TextFormat;
	public var secondaryTextFormat:TextFormat;
	public var minShapeSize:Number;
	public var maxShapeSize:Number;
	
	//internal
	private var shapeInterval:Number;
	private var currentText:Number;
	private var textBox:TextField;
	private var shapes:Array;
	private var shapeTypes:Array;
	private var shapeSize:Number;
	private var usedPositions:Array;
	private var maxShapes:Number;
	
	//*** CONSTRUCTOR ***//
	function RetroCredits(text:Array)
	{
		this.text = text;
		this.shapes = new Array();
		
		this.shapeUpdateTime = 10;
		this.textFadeInTime = 500;
		this.textFadeOutTime = 800;
		this.loop = false;
		
		this.minShapeSize = 20;
		this.maxShapeSize = 30;
		this.shapeColors = [0x7F735C, 0x57595E, 0xF7EBD4, 0xFFFFFF];
		this.primaryTextFormat = new TextFormat("Arial", 20, 0xffffff);
		this.secondaryTextFormat = new TextFormat("Arial", 16, 0xff8800);
		
		//create the textfield for the credits
		this.textBox = this.createTextField("textBox", 0, 0, 0, 0, 0);
		this.textBox.selectable = false;
		this.textBox.autoSize = "left";
		this.textBox.embedFonts = true;
		this.textBox._alpha = 0;
		this.currentText = 0; //initialize to the first credit
		
		this.shapeTypes = ["circle","star","circle","circle"]; // 1/4 of the shapes are stars
	}
	
	//*** PUBLIC FUNCTIONS ***//
	public function redraw():Void
	{
		//generate the current shape size
		this.shapeSize = Math.ceil(Math.random() * (this.maxShapeSize - this.minShapeSize)) + this.minShapeSize - 1;
		
		//initialize the positions table and remove the old shapes 
		this.resetCanvas();
		
		//update the credits text
		this.textBox.setNewTextFormat(this.primaryTextFormat);
		this.textBox.text = this.text[this.currentText].name.toUpperCase();
		this.textBox.text += "\n" + this.text[this.currentText].title.toUpperCase();
		this.textBox.setTextFormat(this.text[this.currentText].name.length, this.textBox.length, this.secondaryTextFormat);
		
		//set the credits text position randomly
		var xPos:Number = Math.ceil(Math.random() * ((this.__width - this.textBox._width) / this.shapeSize)) - 1;
		var yPos:Number = Math.ceil(Math.random() * ((this.__height - this.textBox._height) / this.shapeSize)) - 1;
		this.textBox._x = Math.min(this.__width, xPos * this.shapeSize + this.shapeSize / 2);
		this.textBox._y = Math.min(this.__height, yPos * this.shapeSize + this.shapeSize / 2);
		
		//determine how many shape positions the credits text uses
		var textSize:Number = 0;
		var savedYPos = yPos;
		for(var i:Number = 0; i < this.textBox._width + this.shapeSize; i += this.shapeSize)
		{
			yPos = savedYPos;
			for(var j:Number = 0; j < this.textBox._height + this.shapeSize; j += this.shapeSize)
			{
				this.usedPositions[xPos][yPos] = true;
				yPos++;
				textSize++;
			}
			xPos++;
		}
		
		//we can't hold any more shapes than this
		this.maxShapes = this.usedPositions.length * this.usedPositions[0].length - textSize;
		
		//fade in the current credit
		var fadeText:Tween = new Tween(this, 0, 100, this.textFadeInTime);
		fadeText.setTweenHandlers("onFadeUpdate", "onFadeUpdate");
		
		//start the shape drawing interval
		this.shapeInterval = setInterval(this, "addNewShape", this.shapeUpdateTime);
	}
	
	//*** PRIVATE FUNCTIONS ***//
	private function addNewShape():Void
	{
		//if we've used 90% of the max shapes, it's time for the next credit
		if(this.shapes.length >= this.maxShapes * 0.9)
		{
			clearInterval(this.shapeInterval);
			this.shapeInterval = setInterval(this, "fadeOutCurrentCredit", 800);
			return;
		}
		
		//generate the current shape
		var type:Number = Math.ceil(Math.random() * this.shapeTypes.length) - 1;
		var currentShape:MovieClip = this.attachMovie(this.shapeTypes[type], "shape" + this.shapes.length, this.getNextHighestDepth());
		this.shapes.push(currentShape);
		currentShape._alpha = Math.ceil(Math.random() * 100) - 1;
		currentShape._width = this.shapeSize;
		currentShape._height = this.shapeSize;
		
		//set the color for the current shape
		var transform:Color = new Color(currentShape);
		transform.setRGB(this.shapeColors[Math.ceil(Math.random() * shapeColors.length) - 1]);
		
		//generate the new position
		var xPos:Number;
		var yPos:Number;
		do
		{
			xPos = Math.ceil(Math.random() * (this.__width / this.shapeSize)) - 1;
			yPos = Math.ceil(Math.random() * (this.__height / this.shapeSize)) - 1;
		}
		//we don't want to cover up a position that's already used!
		while(this.usedPositions[xPos][yPos])
		this.usedPositions[xPos][yPos] = true; //mark as used
		
		currentShape._x = xPos * shapeSize;
		currentShape._y = yPos * shapeSize;
	}
	
	//initialization for each new credit
	private function resetCanvas():Void
	{
		//remove the shapes from the last frame
		for(var i:Number = 0; i < this.shapes.length; i++)
			this.shapes[i].removeMovieClip();
		this.shapes = new Array();
		
		//reset the positions based on the shape size
		this.usedPositions = new Array();
		for(var i:Number = 0; i < Math.ceil(this.__width / this.shapeSize); i++)
		{
			this.usedPositions.push([]);
			for(var j:Number = 0; j < Math.ceil(this.__height / this.shapeSize); j++)
				this.usedPositions[this.usedPositions.length - 1].push(false);
		}
	}
	
	private function fadeOutCurrentCredit():Void
	{
		clearInterval(this.shapeInterval);
		var fadeText:Tween = new Tween(this, 100, 0, this.textFadeOutTime);
		fadeText.setTweenHandlers("onFadeUpdate", "onFadeEnd");
	}
	
	//fading event
	private function onFadeUpdate(event:Number):Void
	{
		this.textBox._alpha = event;
	}
	
	//end of fading (only used on fade out)
	private function onFadeEnd(event:Number):Void
	{
		this.onFadeUpdate(event);
		
		//get ready for the next credit
		this.currentText++;
		
		//when finished, restart from the beginning
		if(this.currentText >= this.text.length)
		{
			this.currentText = 0;
			if(!this.loop) //if we aren't looping, then stop
			{
				this.resetCanvas();
				return;
			}
		}
		this.redraw();
	}
}
