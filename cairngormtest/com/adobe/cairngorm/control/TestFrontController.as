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
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.mocks.MockCommand;
	import com.adobe.cairngorm.mocks.MockICommand;
	
	import flexunit.framework.TestCase;

	public class TestFrontController extends TestCase 
	{		
		public static var executeCalled : Boolean = false;
		public static var dispatchedEvent : CairngormEvent;

		private var frontController : FrontController;
		private var eventName : String;
		
		public function TestFrontController( methodName : String = null ) 
		{
			super( methodName );
		}
		
		override public function setUp() : void 
		{
			frontController = new FrontController();
			executeCalled  = false;
			dispatchedEvent = null;
			
			eventName = createNewEventName();
		}
		
		public function testAddCommandNullCommandName() : void 
		{
			try 
			{
				frontController.addCommand( null, MockCommand );
				fail( "addCommand() should fail when null is passed as  command name" );
			}
			catch ( e : CairngormError ) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_NAME_NULL, e.message )
			}
		}
		
		public function testAddCommandNullCommandRef() : void 
		{
			try 
			{
				frontController.addCommand( eventName, null );
				fail( "addCommand() should fail when null is passed instead of class" );
			}
			catch ( e : CairngormError) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_REF_NULL, e.message )
			}
		}
		
		public function testAddCommandClassDoesNotImplementICommand() : void 
		{
			try 
			{
				frontController.addCommand( eventName, TestCase );
				fail( "addCommand() should fail for a class that does not implement the com.adobe.cairngorm.commands.ICommand interface" );
			}
			catch ( e : CairngormError ) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_SHOULD_IMPLEMENT_ICOMMAND, e.message )
			}
		}
		
		public function testAddCommandClassDoesNotImplementCommand() : void 
		{
			try 
			{
				frontController.addCommand( eventName, TestCase );
				fail( "addCommand() should fail for a class that does not implement the com.adobe.cairngorm.commands.Command interface" );
			}
			catch ( e : CairngormError ) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_SHOULD_IMPLEMENT_ICOMMAND, e.message )
			}
		}
		
		public function testAddCommandClassImplementsICommand() : void 
		{
			frontController.addCommand( eventName, MockICommand );
			assertTrue( "CairngormEventDispatcher should be listening for event", CairngormEventDispatcher.getInstance().hasEventListener( eventName ) );
		}
		
		public function testAddCommandClassImplementsCommand() : void 
		{
			frontController.addCommand( eventName, MockCommand );
			assertTrue( "CairngormEventDispatcher should be listening for event", CairngormEventDispatcher.getInstance().hasEventListener( eventName ) );
		}

		public function testAddCommandTwiceWithSameCommandName() : void 
		{
			try 
			{
				frontController.addCommand( eventName, MockCommand );
				frontController.addCommand( eventName, MockICommand );
				
				fail( "Calling addCommand() twice with the same command name should fail" );
			}
			catch ( e : CairngormError ) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_ALREADY_REGISTERED, e.message )
			}
		}
		
		public function testCommandExecuteCalled() : void
		{			
			frontController.addCommand( eventName, LocalCommand );
			
			var event : CairngormEvent = new CairngormEvent( eventName );
			event.dispatch();
			
			assertTrue( "execute should have been called", TestFrontController.executeCalled );
			assertNotNull( "dispatchedEvent should not be null", TestFrontController.dispatchedEvent );
			assertEquals( event, TestFrontController.dispatchedEvent );
		}
		
		public function testAddCommandDispatcherHasEventListener() : void 
		{
			frontController.addCommand( eventName, MockCommand );
				
			assertTrue( "CairngormEventDispatcher should be listening for event", CairngormEventDispatcher.getInstance().hasEventListener( eventName ) );
		}
		
		public function testRemoveCommandNullCommandName() : void 
		{
			try
			{
				frontController.removeCommand( null );
				fail( "removeCommand() should fail for a null commandName" );
			}
			catch ( e : CairngormError ) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_NAME_NULL, e.message )
			}
		}

		public function testRemoveCommandCommandNotRegistered() : void 
		{
			try
			{
				frontController.removeCommand( eventName );
				fail( "removeCommand() should fail for a unregistered commandName" );
			}
			catch ( e : CairngormError ) 
			{
				verifyMessageCode( CairngormMessageCodes.COMMAND_NOT_REGISTERED, e.message )
			}
		}

		public function testRemoveCommand() : void 
		{
			frontController.addCommand( eventName, MockCommand );				
			assertTrue( "CairngormEventDispatcher should be listening for event", CairngormEventDispatcher.getInstance().hasEventListener( eventName ) );
			
			frontController.removeCommand( eventName );
			assertFalse( "CairngormEventDispatcher should not be listening for event", CairngormEventDispatcher.getInstance().hasEventListener( eventName ) );
		}

		public function testRemoveCommandCanAddAgain() : void 
		{
			frontController.addCommand( eventName, MockCommand );
			frontController.removeCommand( eventName );
			frontController.addCommand( eventName, MockCommand );

			assertTrue( "CairngormEventDispatcher should be listening for event", CairngormEventDispatcher.getInstance().hasEventListener( eventName ) );
		}

		
		private function verifyMessageCode( messageCode : String, message : String ) : void
		{
			assertTrue( "Message code should be " + messageCode, message.indexOf( messageCode ) == 0 );			
		}
		
		private function createNewEventName() : String
		{
			return "event" + new Date().getTime();
		}
	}
}
	
import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import com.adobe.cairngorm.control.TestFrontController;

class LocalCommand implements ICommand
{
	public function execute( event : CairngormEvent ) : void
	{
		TestFrontController.executeCalled = true;
		TestFrontController.dispatchedEvent = event;
	}
}
