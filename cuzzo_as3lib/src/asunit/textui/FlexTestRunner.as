package asunit.textui 
	import asunit.textui.TestRunner;

		public function FlexTestRunner() 
			setPrinter(new ResultPrinter());
		}

			if(event.target === this) 
				parent.addEventListener(Event.RESIZE, resizeHandler);
				resizeHandler(new Event(Event.RESIZE));
			}
			else 
				event.stopPropagation();
			}
		}

			fPrinter.width = w;
		}

			fPrinter.height = h;
		}

			width = parent.width;
			height = parent.height;
		}

			if(parent && child is IUIComponent) 
				// AND check for 'is' UIUComponent...
				return parent.addChild(child);
			}
			else 
				return super.addChild(child);
			}
		}

			if(child is IUIComponent) 
				return parent.removeChild(child);
			}
			else 
				return super.removeChild(child);
			}
		}
	}
}