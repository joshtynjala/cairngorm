/*
Copyright (c) 2008. Adobe Systems Incorporated.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from this
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

@ignore
*/
package com.adobe.cairngorm.control 
{
	import flexunit.framework.TestCase;

	public class TestCairngormEventDispatcher extends TestCase 
	{		
		private var listenerCalled : Boolean;
		private var dispatchedEvent : CairngormEvent;

		private var eventName : String;
		
		public function TestCairngormEventDispatcher( methodName : String = null ) 
		{
			super( methodName );
		}
		
		override public function setUp() : void 
		{
			listenerCalled  = false;
			dispatchedEvent = null;
			
			eventName = createNewEventName();
		}		
		
		public function testGetInstance() : void
		{
			assertNotNull( "getInstance should not be null", CairngormEventDispatcher.getInstance() );
		}
		
		public function testEventDispatched() : void
		{
			var dispatcher : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
			
			dispatcher.addEventListener( eventName, dispatchListener );
			
			dispatcher.dispatchEvent( new CairngormEvent( eventName ) );
						
			assertTrue( "listenerCalled should be true" );
			assertNotNull( "dispatchedEvent was null", dispatchedEvent );
			assertEquals( eventName, dispatchedEvent.type );
		}

		public function testRemoveEventListener() : void
		{
			var dispatcher : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
			
			dispatcher.addEventListener( eventName, dispatchListener );
			dispatcher.removeEventListener( eventName, dispatchListener  );
			
			dispatcher.dispatchEvent( new CairngormEvent( eventName ) );
						
			assertFalse( "listenerCalled should not be true", listenerCalled );
			assertNull( "dispatchedEvent should be null", dispatchedEvent );
		}

		public function testHasEventListener() : void
		{
			var dispatcher : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
			
			dispatcher.addEventListener( eventName, dispatchListener );
			
			dispatcher.dispatchEvent( new CairngormEvent( eventName ) );
						
			assertTrue( "hasEventListener() should be true", dispatcher.hasEventListener( eventName ) );
		}

		public function testWilLTrigger() : void
		{
			var dispatcher : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
			dispatcher.addEventListener( eventName, dispatchListener );
			
			dispatcher.dispatchEvent( new CairngormEvent( eventName ) );
						
			assertTrue( "willTrigger() should be true", dispatcher.willTrigger( eventName ) );
		}
				
		private function dispatchListener( event : CairngormEvent ) : void
		{
			listenerCalled = true;
			dispatchedEvent = event;
		}
		
		private function createNewEventName() : String
		{
			return eventName + new Date().getTime();
		}		
	}
}
	
