<?php

namespace Guaroj;

use Error;
use Exception;

class Command
{

    protected static $instance;

    public function __construct(private array $arguments = [])
    {
        $this->arguments = $argv ?? $_SERVER['argv'] ?? [];
    }

    private static function getNamespace($namespace='Commands')
    {
        return $_ENV['APP_NAMESPACE'].'\\'.\ucfirst($namespace).'\\';
    }

    public function processCommand()
    {
        $commandFileName = $_ENV['COMMANDS_PATH'] .'/'. $this->getCommandName() .'.php';
        $commandClass = $this->getNamespace('Commands') . $this->getCommandName();
        if(is_file($commandFileName)) {
            require $commandFileName;
            if (class_exists($commandClass)) {
                $commandObject = new $commandClass();
                $commandObject->run();
            } else {
                throw new Error('No exists class '.$commandClass);
            }
        } else {
            throw new Error('No exists file '.$commandFileName);
        }

    }

    public function getCommandName()
    {
        if(!isset($this->arguments[1])) {
            throw new Error("Command is required!!!");
        }
        return ucfirst($this->arguments[1]);
    }

    public static function getInstance()
    {
        if (is_null(static::$instance)) {
            static::$instance = Container::getInstance()->get(Command::class);
        }

        return static::$instance;
    }

}
