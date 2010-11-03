package com.atmospherebbdo.collections {	import com.atmospherebbdo.collections.AbstractArrayIterator;	import com.atmospherebbdo.collections.AbstractCollection;	import com.atmospherebbdo.collections.IIterator;	import com.atmospherebbdo.collections.events.CollectionEvent;	import com.atmospherebbdo.dbc.precondition;	import com.atmospherebbdo.errors.NoSuchElementError;		/**	 * @author markhawley	 * 	 * Iterator that proceeds backwards over an array.	 */	public class ArrayReverseIterator extends AbstractArrayIterator implements IIterator 	{		/**		 * Constructor.		 * 		 * @param	collection	ICollection		 * @param	implementation	Array		 */		public function ArrayReverseIterator( collection:AbstractCollection, implementation:Array )		{			super( collection, implementation );						reset();		}		/**		 * Returns true as long as the collection is not empty and		 * there is an element following the current one.		 * 		 * @return Boolean		 */		public function hasNext():Boolean		{			precondition(!invalid, "Invalid iteration over a changed collection.");						if (index != 0)			{				return true;			}			else			{				return false;			}		}				/**		 * Returns the next element in the collection.		 */		public function next():*		{			precondition(!invalid, "Invalid iteration over a changed collection.");						if (!hasNext())			{				throw new NoSuchElementError();			}			index--;			return impl[index];			}				/**		 * Returns the iterator to the start of the collection.		 */		public function reset():void		{			index = impl.length;			invalid = false;		}				/**		 * Handles CollectionEvent.CHANGE on iterated collection by marking the		 * iterator invalid.		 * 		 * @param	event	CollectionEvent		 */		override protected function onCollectionChange( event:CollectionEvent ) :void		{			invalid = true;		}	}}