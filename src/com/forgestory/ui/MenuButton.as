package com.forgestory.ui
{
	import com.greensock.TweenLite;
	import com.pblabs.engine.debug.Logger;
	import com.zerojuan.ui.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class MenuButton extends Component{
		public static const FORGE:String = "Forge";
		public static const HOME:String = "Home";
		public static const SHOP:String = "Shop";
		public static const ADVENTURE:String = "Adventure";
		
		private var _type:String;
		
		private var _over:Boolean = false;
		private var _down:Boolean = false;
		private var _selected:Boolean = false;
		private var _toggle:Boolean = false;
		
		private var _buttonMC:MovieClip;
		private var _back:Sprite;
		
		private var _xPos:Number;
		private var _yPos:Number;
		
		
		public function MenuButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, type:String = "Forge", handler:Function = null){
			_type = type;
			_xPos = xpos;
			_yPos = ypos;
			super(parent, xpos, ypos);
			
			if(handler != null){
				_buttonMC.addEventListener(MouseEvent.CLICK, handler);
			}
		}
		
		override protected function init():void{
			super.init();
			buttonMode = true;
			useHandCursor = true;
			setSize(65, 100);
		}
		
		override protected function addChildren():void{
			_back = new Sprite();
			_back.mouseEnabled = false;
			addChild(_back);
			
			_buttonMC = getButtonMC(_type);
			_buttonMC.mouseEnabled = true;
			addChild(_buttonMC);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		override public function draw():void{
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(GameUIStyle.RED_HIGHLIGHT);
			_back.graphics.drawRect(-_buttonMC.width / 2, 0, _buttonMC.width, _buttonMC.height * 2);
			_back.graphics.endFill();
		}

		protected function onMouseOver(event:MouseEvent):void{
			if(!_enabled){
				return;
			}
			_over = true;
			Logger.print(this, "OnMouseOver");
			TweenLite.to(this, .2, {y: _yPos - 15});
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			if(!_enabled){
				return;
			}
			_over = false;
			Logger.print(this, "OnMouseOut");
			TweenLite.to(this, .2, {y: _yPos});
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		protected function onMouseGoDown(event:MouseEvent):void{
			_down = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMouseGoUp(event:MouseEvent):void{
			if(_toggle && _over){
				_selected = !_selected;
			}
			_down = _selected;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		private function getButtonMC(type:String):MovieClip{
			switch(type){
				case FORGE:	return new ForgeMC();
				case HOME: return new HomeMC();
				case SHOP: return new ShopMC();
				case ADVENTURE: return new AdventureMC();
			}
			return null;
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			tabEnabled = value;
			//alpha = _enabled ? 1.0 : 0.5;
		}
		
		override public function get enabled():Boolean
		{
			return _enabled;
		}
	}
}