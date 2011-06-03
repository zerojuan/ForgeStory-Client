package com.forgestory.ui
{
	import com.forgestory.rpg.Avatar;
	import com.zerojuan.ui.Panel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class AvatarPanel extends Panel{		
		public var avatar:Avatar;
		
		public var _avatarBackground:Sprite;
		
		private var _borderThickness:int = 10;
		
		
		public function AvatarPanel(parent:DisplayObjectContainer = null, xPos:Number = 0, yPos:Number = 0, avatar:Avatar = null){
			if(!avatar){
				this.avatar = new Avatar();
			}else{
				this.avatar = avatar;
			}
			
			width = 200;
			height = 400;
			
			super(parent, xPos, yPos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(280, 380);
		}
		
		override protected function addChildren():void{
			_background = new Sprite();
			super.addRawChild(_background);
			
			_mask = new Sprite();
			_mask.mouseEnabled = false;
			super.addRawChild(_mask);
			
			content = new Sprite();
			super.addRawChild(content);
			content.mask = _mask;
			
			_avatarBackground = new Sprite();
			content.addChild(_avatarBackground);
			
			content.addChild(avatar);
		}
		
		override public function draw():void{
			super.draw();
			_background.graphics.clear();
			_background.graphics.lineStyle(1, GameUIStyle.MAIN_HIGHLIGHT, 1);
			_background.graphics.beginFill(GameUIStyle.MAIN_HIGHLIGHT);
			_background.graphics.drawRect(-_borderThickness, -_borderThickness, _width + (_borderThickness * 2), _height + (_borderThickness * 2));
			_background.graphics.endFill();
			
			_avatarBackground.graphics.beginFill(0xFFFFFF);
			_avatarBackground.graphics.drawRect(0,0, _width, _height);
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
		}
		
		public function addToBackground(bg:DisplayObject):void{
			_avatarBackground.addChild(bg);
		}
	}
}