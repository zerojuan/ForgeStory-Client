package com.forgestory.paint
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class AcknowledgementPanel extends Panel
	{
		public var itemImage:Bitmap;
		
		
		private var descriptionLabel:Label;
		private var shareButton:PushButton;
		private var notNowButton:PushButton;
		
		private var _itemName:String;
		
		private var _shareCallback:Function;
		private var _cancelCallback:Function;
		
		public function AcknowledgementPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
			width = 250;
			height = 100;
			
			itemImage = new Bitmap();
			itemImage.x = 5;
			itemImage.y = 5;
			addChild(itemImage);
			
			descriptionLabel = new Label(this, 75, 5, "Successfully forged the " + _itemName+", use it in your quests. And you will be rewarded handsomely. Because you are so handsome.");
			descriptionLabel.autoSize = true;
			descriptionLabel.textField.width = 160;
			descriptionLabel.textField.wordWrap = true;
			
			shareButton = new PushButton(this, 70, 75, "Share");
			shareButton.width = 40;
			notNowButton = new PushButton(this, 150, 75, "not now");
			notNowButton.width = 45;
		}
		
		public function set itemName(val:String):void{
			this._itemName = val;
			descriptionLabel.text = "Successfully forged the " + _itemName+", use it in your quests. And you will be rewarded handsomely. Because you are so handsome.";
		}
		
		public function set shareCallback(val:Function):void{
			_shareCallback = val;
			shareButton.addEventListener(MouseEvent.CLICK, _shareCallback);
		}
		
		public function set cancelCallback(val:Function):void{
			_cancelCallback = val;
			notNowButton.addEventListener(MouseEvent.CLICK, _cancelCallback);
		}
	}
}