<?php

namespace Backend;

use Guaroj\DB;
use Dotenv\Dotenv;
use Guaroj\Container;
use Guaroj\Route;
use Guaroj\Command;
use Guaroj\Auth;
use Exception;
use Error;

class BackendKernel {

    public Container $container;

    public function __construct() {
        $this->loadEnv();
        $this->configContainer();
        $this->initDatabase();
        $this->processCommand();
    }

    private function configContainer(): BackendKernel
    {
        $this->container = Container::getInstance()
            ->setDefinitions(__DIR__ . "/BackendConfig.php")
            ->build();
        return $this;
    }

    private function loadEnv(): BackendKernel
    {
        $dotenv = Dotenv::createImmutable(__DIR__);
        $dotenv->load();
        return $this;
    }

    private function initDatabase(): BackendKernel
    {
        if(isset($_ENV["DB_HOST"])) {
            $this->db = $this->container->get(DB::class);
        }
        return $this;
    }

    private function processCommand()
    {
        $command = $this->container->get(Command::class);
        $command->processCommand();
    }

}
