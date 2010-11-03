package asunit.textui 
	import asunit.framework.Test;
		private var fColumn:int = 0;
		private var textArea:TextField;
		private var gutter:uint = 0;
		private var backgroundColor:uint = 0x333333;
		private var bar:SuccessBar;
		private var barHeight:Number = 3;
		private var showTrace:Boolean;
		private var startTime:Number;
		private var testTimes:Array;

			this.showTrace = showTrace;
			testTimes = new Array();
			configureAssets();
			println();

			// Create a loop so that the FDBTask
			// can halt execution properly:
			setInterval(function():void 
			}, 500);
		}

			textArea = new TextField();
			textArea.background = true;
			textArea.backgroundColor = backgroundColor;
			textArea.border = true;
			textArea.wordWrap = true;
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.color = 0xFFFFFF;
			textArea.defaultTextFormat = format;
			addChild(textArea);
			println("AsUnit " + Version.id() + " by Luke Bayes and Ali Mills");
			println("");
			println("Flash Player version: " + Capabilities.version);

			bar = new SuccessBar();
			addChild(bar);
		}

			this.showTrace = showTrace;
		}

			textArea.x = gutter;
			textArea.width = w - gutter * 2;
			bar.x = gutter;
			bar.width = textArea.width;
		}

			textArea.height = h - ((gutter * 2) + barHeight);
			textArea.y = gutter;
			bar.y = h - (gutter + barHeight);
			bar.height = barHeight;
		}

			textArea.appendText(args.toString() + "\n");
		}

			textArea.appendText(args.toString());
		}

		 * API for use by textui.TestRunner
		 */
		public function run(test:Test):void 
		}

			printHeader(runTime);
			printErrors(result);
			printFailures(result);
			printFooter(result);

			bar.setSuccess(result.wasSuccessful());
			if(showTrace) 
				trace(textArea.text.split("\r").join("\n"));
			}
		}

		 */
		protected function printHeader(runTime:Number):void 
			println();
			println();
			println("Time: " + elapsedTimeAsString(runTime));
		}

			printDefects(result.errors(), result.errorCount(), "error");
		}

			printDefects(result.failures(), result.failureCount(), "failure");
		}

			if (count == 0) 
				return;
			}
			if (count == 1) 
				println("There was " + count + " " + type + ":");
			}
			else 
				println("There were " + count + " " + type + "s:");
			}
			var i:uint;
			for each (var item:TestFailure in booBoos) 
				printDefect(TestFailure(item), i);
				i++;
			}
		}

			printDefectHeader(booBoo, count);
			printDefectTrace(booBoo);
		}

			// I feel like making this a println, then adding a line giving the throwable a chance to print something
			// before we get to the stack trace.
			var startIndex:uint = textArea.text.length;
			println(count + ") " + booBoo.failedFeature());
			var endIndex:uint = textArea.text.length;

			var format:TextFormat = textArea.getTextFormat();
			format.bold = true;

			// GROSS HACK because of bug in flash player - TextField isn't accepting formats...
			setTimeout(onFormatTimeout, 1, format, startIndex, endIndex);
		}

			textArea.setTextFormat(format, startIndex, endIndex);
		}

			println(BaseTestRunner.getFilteredTrace(booBoo.thrownException().getStackTrace()));
		}

			println();
			if (result.wasSuccessful()) 
				print("OK");
				println(" (" + result.runCount() + " test" + (result.runCount() == 1 ? "" : "s") + ")");
			} 
				println("FAILURES!!!");
				println("Tests run: " + result.runCount() + ",  Failures: " + result.failureCount() + ",  Errors: " + result.errorCount());
			}
			
			printTimeSummary();
			println();
		}

			testTimes.sortOn('duration', Array.NUMERIC | Array.DESCENDING);
			println();
			println();
			println('Time Summary:');
			println();
			var len:Number = testTimes.length;
			for(var i:Number = 0;i < len; i++) 
				println(testTimes[i].duration + 'ms : ' + testTimes[i].name);
			}
		}

		 * Returns the formatted string of the elapsed time.
		 * Duplicated from BaseTestRunner. Fix it.
		 */
		protected function elapsedTimeAsString(runTime:Number):String 
			return Number(runTime / 1000).toString();
		}

		 * @see asunit.framework.TestListener#addError(Test, Throwable)
		 */
		public function addError(test:Test, t:Error):void 
			print("E");
		}

		 * @see asunit.framework.TestListener#addFailure(Test, AssertionFailureError)
		 */
		public function addFailure(test:Test, t:AssertionFailureError):void 
			print("F");
		}

		 * @see asunit.framework.TestListener#endTestMethod(test, testMethod);
		 */
		public function startTestMethod(test:Test, methodName:String):void 
		}

		 * @see asunit.framework.TestListener#endTestMethod(test, testMethod);
		 */
		public function endTestMethod(test:Test, methodName:String):void 
		}

		 * @see asunit.framework.TestListener#startTest(Test)
		 */
		public function startTest(test:Test):void 
			startTime = getTimer();
			var count:uint = test.countTestCases();
			for(var i:uint;i < count; i++) 
				print(".");
				if (fColumn++ >= 80) 
					println();
					fColumn = 0;
				}
			}
		}

		 * @see asunit.framework.TestListener#endTest(Test)
		 */
		public function endTest(test:Test):void 
			var duration:Number = getTimer() - startTime;
			testTimes.push({name: test.getName(), duration: duration});
		}
	}
}


	private var myWidth:uint;
	private var myHeight:uint;
	private var bgColor:uint;
	private var passingColor:uint = 0x00FF00;
	private var failingColor:uint = 0xFD0000;

	}

		bgColor = (success) ? passingColor : failingColor;
		draw();
	}

		myWidth = num;
		draw();
	}

		myHeight = num;
		draw();
	}

		graphics.clear();
		graphics.beginFill(bgColor);
		graphics.drawRect(0, 0, myWidth, myHeight);
		graphics.endFill();
	}
}