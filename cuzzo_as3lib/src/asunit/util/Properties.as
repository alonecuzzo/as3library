package asunit.util 
{
	import com.atmospherebbdo.errors.UnimplementedFeatureError;



		public function store(sharedObjectId:String):void 
			throw new UnimplementedFeatureError("Properties.store");
		}

			this[key] = value;
		}

			put(key, value);
		}

			try 
				return this[key];
			}
			catch(e:Error) 
				throw IllegalOperationError("Properties.getProperty");
			}
			return null;
		}
	}
}