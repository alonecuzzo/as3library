package br.com.stimuli.loading.loadingtypes 
	import br.com.stimuli.loading.BulkLoader;

	public class ImageItem extends LoadingItem 
		public var loader:Loader;

			specificAvailableProps = [BulkLoader.CONTEXT];
			super(url, type, uid);
		}

			_context = props[BulkLoader.CONTEXT] || null;
            
			return super._parseOptions(props);
		}

			super.load();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 100, true);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);  
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
			try
				// TODO: test for security error thown.
				loader.load(url, _context);
			}catch( e:SecurityError)
				onSecurityErrorHandler(_createErrorEvent(e));
			}
		};

			_httpStatus = evt.status;
			dispatchEvent(evt);
		}

			super.onErrorHandler(evt);
		}

			// TODO: test for the different behaviour when loading items with 
			// the a specific crossdomain and without one
			try
				// of no crossdomain has allowed this operation, this might
				// raise a security error
				_content = loader.content;
				super.onCompleteHandler(evt);
			}catch(e:SecurityError)
				// we can still use the Loader object (no dice for accessing it as data
				// though. Oh boy:
				_content = loader;
				super.onCompleteHandler(evt);
	        	// I am really unsure whether I should throw this event
	        	// it would be nice, but simply delegating the error handling to user's code 
	        	// seems cleaner (and it also mimics the Standar API behaviour on this respect)
	        	//onSecurityErrorHandler(e);
			}
		};

			try
				if(loader)
					loader.close();
				}
			}catch(e:Error)
			}
			super.stop();
		};

			if (loader)
				var removalTarget:Object = loader.contentLoaderInfo;
				removalTarget.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
				removalTarget.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
				removalTarget.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
				removalTarget.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
				removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
			}
		}

			return (type == BulkLoader.TYPE_IMAGE);
		}

			return (type == BulkLoader.TYPE_MOVIECLIP);
		}

			stop();
			cleanListeners();
			_content = null;
			loader = null;
		}
	}
}