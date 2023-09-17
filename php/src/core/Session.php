<?php

namespace Guaroj;

class Session
{

	public static function start(int $cache_expire_in_minutes = 5)
	{
		session_cache_expire($cache_expire_in_minutes);
		session_start();
		header('P3P: CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"');
		header("Cache-control: private");
	}

	public static function set($name, $value)
	{
		if(!empty($name))
		{
			$_SESSION[$name]=$value;
		}
	}

	public static function get($name)
	{
		if(self::isset($name))
		{
			return $_SESSION[$name];
		}
		//die ($name." no se ha cargado en session.");
		return null;
	}

	public static function unset($name)
	{
		if( self::isset($name) )
		{
			unset($_SESSION[$name]);
			return true;
		}
		return false;
	}

	public static function isset($name)
	{
		return isset($_SESSION[$name]);
	}

	public static function getID()
	{
		return session_id();
	}


	public function close()
	{
		session_unset();
	}


}
?>
