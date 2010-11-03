package com.atmospherebbdo.util {	/**	 * @author markhawley	 * 	 * An interface marking objects as specialized for use with an ObjectPool.	 * This interface strongly implies (but can not enforce) static methods	 * getFromPool( ...constructorParams ) and sendToPool( i:IPoolable ) be	 * present.	 */	public interface IPoolable 	{		/**		 * Returns true if the object has been sent to an ObjectPool. This		 * method should only be used in error checking.		 * 		 * @return Boolean, true if the object has been sent to an ObjectPool.		 */		function get inPool() :Boolean;	}}