package com.forgestory.rpg
{
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class BuySuccessWindow extends Window
	{
		private var buySuccessPanel:BuySuccessPanel;
		
		public function BuySuccessWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")
		{
			super(parent, xpos, ypos, title);
			hasCloseButton = true;
			width = 250;
			height = 120;
			addEventListener(Event.CLOSE, onCloseBuyWindow);
			
			buySuccessPanel = new BuySuccessPanel();
			buySuccessPanel.cancelCallback = onCloseBuyWindow;
			
			content.addChild(buySuccessPanel);
		}
		
		private function onCloseBuyWindow(evt:Event):void{
			visible = false;
			dispatchEvent(evt);
		}
	}
}