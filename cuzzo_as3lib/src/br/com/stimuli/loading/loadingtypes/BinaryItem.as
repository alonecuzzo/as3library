package br.com.stimuli.loading.loadingtypes 
	import br.com.stimuli.loading.BulkLoader;

	public class BinaryItem extends LoadingItem 
		public var loader:URLLoader;

			super(url, type, uid);
		}

			return super._parseOptions(props);
		}

			super.load();
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
			loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
			try
				// TODO: test for security error thown.
				loader.load(url);
			}catch( e:SecurityError)
				onSecurityErrorHandler(_createErrorEvent(e));
			}
		};

			super.onErrorHandler(evt);
		}

			super.onStartedHandler(evt);
		};

			// _content = new ByteArray(loader.data);
			_content = evt.target.data;
			super.onCompleteHandler(evt);
		};

			try
				if(loader)
					loader.close();
				}
			}catch(e:Error)
			}
			super.stop();
		};

			if(loader)
				loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
				loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
				loader.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
			}
		}

			stop();
			cleanListeners();
			_content = null;
			loader = null;
		}   
	}	
}