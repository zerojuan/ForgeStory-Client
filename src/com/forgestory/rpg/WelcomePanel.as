package com.forgestory.rpg
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class WelcomePanel extends Panel
	{
		private var descriptionLabel:Label;
		private var notNowButton:PushButton;
		
		private var _cancelCallback:Function;
		
		public function WelcomePanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0){
			super(parent, xpos, ypos);
			
			width = 250;
			height = 100;
			
			descriptionLabel = new Label(this, 20, 5, "Welcome, " + PlayerData.instance.player.username + ". You are in a game about forging items and selling them. Also you forge monsters and fight them. If this is the game you are waiting for your whole life, then click the button below. ");
			descriptionLabel.autoSize = true;
			descriptionLabel.textField.width = 200;
			descriptionLabel.textField.wordWrap = true;
			
			notNowButton = new PushButton(this, 120, 75, "Proceed");
			notNowButton.width = 45;
		}
		
		public function set cancelCallback(val:Function):void{
			_cancelCallback = val;
			notNowButton.addEventListener(MouseEvent.CLICK, _cancelCallback);
		}
		
		public function setMessage(str:String):void{
			descriptionLabel.text = str;
		}
	}
}