package com.zerojuan.ui
{
	import com.pblabs.engine.debug.Logger;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends Component
	{
		protected var _autoSize:Boolean = true;
		protected var _text:String = "";
		protected var _tf:TextField;
		
		public var fontName:String = "Redhead";
		public var fontHeight:Number = 60;
		public var fontColor:uint = 0xc4eafd;
		
		public function Label(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="")
		{
			this.text = text;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_height = 18;
			_tf = new TextField();
			_tf.height = _height;
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = new TextFormat(fontName, fontHeight, fontColor);
			_tf.text = _text;			
			addChild(_tf);
			draw();
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public function setStyle(fontName:String, fontHeight:Number, fontColor:uint):void{
			this.fontName = fontName;
			this.fontHeight = fontHeight;
			this.fontColor = fontColor;
			
			_tf.defaultTextFormat = new TextFormat(fontName, fontHeight, fontColor);
			invalidate();
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			_tf.text = _text;
			if(_autoSize)
			{
				_tf.autoSize = TextFieldAutoSize.LEFT;
				_width = _tf.width;
				dispatchEvent(new Event(Event.RESIZE));
			}
			else
			{
				_tf.autoSize = TextFieldAutoSize.NONE;
				_tf.width = _width;
			}
			_height = _tf.height = 18;
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text of this Label.
		 */
		public function set text(t:String):void
		{
			_text = t;
			if(_text == null) _text = "";
			invalidate();
		}
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Gets / sets whether or not this Label will autosize.
		 */
		public function set autoSize(b:Boolean):void
		{
			_autoSize = b;
		}
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		/**
		 * Gets the internal TextField of the label if you need to do further customization of it.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
	}
}