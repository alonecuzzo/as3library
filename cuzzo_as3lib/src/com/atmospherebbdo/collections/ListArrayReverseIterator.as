﻿package com.atmospherebbdo.collections {	import com.atmospherebbdo.dbc.precondition;	import com.atmospherebbdo.errors.NoSuchElementError;				/**	 * @author markhawley	 * 	 * Opposite list iterator: starts at last element and proceeds to	 * the first.	 */	public class ListArrayReverseIterator extends ArrayOrderedIterator implements IListIterator 	{		/**		 * Constructor.		 * 		 * @param	collection	IList		 * @param	implementation	Array		 */		public function ListArrayReverseIterator( collection:AbstractCollection, implementation:Array )		{			precondition( collection is IList );						super( collection, implementation );						reset();		}				/**		 * Returns true if the index is greater than 0.		 * 		 * @return	Boolean		 */		public function hasPrevious():Boolean		{			precondition(!invalid, "Invalid iteration over a changed collection.");						if (index != impl.length-1)			{				return true;			}			else			{				return false;			}		}				/**		 * Returns the index at which the next call to next() will		 * pull from.		 * 		 * @return int		 */		public function nextIndex():int		{			precondition(!invalid, "Invalid iteration over a changed collection.");						return index - 1;		}				/**		 * Returns the previous element of the collection.		 * 		 * @return *		 */		public function previous():*		{			precondition(!invalid, "Invalid iteration over a changed collection.");						if (!hasPrevious())			{				throw new NoSuchElementError();			}						index++;			return impl[index];		}				/**		 * Returns the index at which the next call to previous() 		 * will pull from.		 * 		 * @return int		 */		public function previousIndex():int		{			precondition(!invalid, "Invalid iteration over a changed collection.");						return index + 1;		}	}}