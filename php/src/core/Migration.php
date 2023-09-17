<?php

namespace Guaroj;

use Error;
use function Lambdish\Phunctional\filter;
use function Lambdish\Phunctional\map;
use Exception;

class Migration
{

    protected static $instance;
    private string $migrationPath = '';
    private string $seederPath = '';

    public function __construct()
    {
        $this->migrationPath = $_ENV['MIGRATIONS_PATH'].'/';
        $this->seederPath = $_ENV['SEEDERS_PATH'].'/';
    }

    public static function getInstance()
    {
        if (is_null(static::$instance)) {
            static::$instance = Container::getInstance()->get(Migration::class);
        }

        return static::$instance;
    }

    public function processMigration()
    {
        $this->executeMigration($this->migrationPath);
    }

    public function processSeeder()
    {
        $this->executeMigration($this->seederPath);
    }

    public function executeMigration(string $path )
    {
        if(empty($path)) {
            throw new Error("No ha configurado la ruta ".$path." de migración en Config.php");
        }
        $migrationsFilesSQL=self::searchFilesSQL($path);
        if(count($migrationsFilesSQL)<1) {
            throw new Error("No encuentro archivos para migrar");
        }

        $db = DB::getInstance()->getConnection();
        map(static function($file) use($db) {
            static::executeSQLFromSQLFile($db, $file);
        }, $migrationsFilesSQL);
    }

    private static function executeSQLFromSQLFile($db, $filename)
    {
        echo 'Creando ' . $filename . PHP_EOL;
        echo file_get_contents(realpath($filename));
        $db::unprepared(file_get_contents(realpath($filename)));
        echo PHP_EOL;
    }

    private function searchFilesSQL(string $path): array
    {
        try
        {
            $possibleFiles = filter(
                static function ($file) {
                    return self::endsWith('.sql', $file);
                },
                scandir($path)
            );
        } catch (Exception $e) {
            throw new Error("No encuentro archivos para migrar.".$e->getMessage());
        }

        return map(static function($file) use($path) {
            return $path . $file;
        },
        $possibleFiles);
    }

    public static function endsWith(string $needle, string $haystack): bool
    {
        $length = strlen($needle);
        if ($length === 0) {
            return true;
        }

        return (substr($haystack, -$length) === $needle);
    }
}
