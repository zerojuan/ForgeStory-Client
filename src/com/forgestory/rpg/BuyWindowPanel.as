package com.forgestory.rpg
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import com.forgestory.model.Item;

	public class BuyWindowPanel extends Panel{
		public var itemImage:ItemViewer;
		
		private var descriptionLabel:Label;
		private var buyButton:PushButton;
		private var cancelButton:PushButton;
		
		public function BuyWindowPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0){
			super(parent, xpos, ypos);
			
			width = 250;
			height = 100;
			
			itemImage = new ItemViewer();
			itemImage.x = 5;
			itemImage.y = 5;
			addChild(itemImage);
			
			descriptionLabel = new Label(this, 75, 5, "Awesome sauce!");
			descriptionLabel.autoSize = true;
			descriptionLabel.textField.width = 160;
			descriptionLabel.textField.wordWrap = true;
			
			buyButton = new PushButton(this, 70, 75, "Buy");
			buyButton.width = 40;
			cancelButton = new PushButton(this, 150, 75, "Cancel");
			cancelButton.width = 45;
		}
		
		public function setSummary(item:Item):void{
			descriptionLabel.text = "Are you sure you want to buy " + item.name + " for " + item.price + "?" +
				"You will have " + getValueAfterPurchase(item.price) + " after this purchase.";
			itemImage.setURL(item.id+".png");
		}
		
		public function setFreeSummary(item:Item):void{
			descriptionLabel.text = "Are you sure you want to buy " + item.name + " for free  ?" +
				"You are getting this for free. Say yes.";
			itemImage.setURL(item.id+".png");
		}
		
		public function getValueAfterPurchase(price:int):int{
			return PlayerData.instance.player.coins -= price;
		}
		
		public function set buyCallback(val:Function):void{
			buyButton.addEventListener(MouseEvent.CLICK, val);
		}
		
		public function set cancelCallback(val:Function):void{
			cancelButton.addEventListener(MouseEvent.CLICK, val);
		}
	}
}