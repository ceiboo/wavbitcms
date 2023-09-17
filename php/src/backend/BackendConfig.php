<?php

namespace Backend;

use Guaroj\DB;
use Guaroj\Request;
use Guaroj\Command;
use Guaroj\Error;
use Backend\Config\Config;
use DI;

return [
    Error::class => function() { return new Error(); },
    Command::class => function() {
        return new Command(
            $_SERVER["argv"] ?? []
        );
    },
    DB::class => DI\autowire()->constructorParameter("dbConnection", [
        "driver" => $_ENV["DB_DRIVER"],
        "host" => $_ENV["DB_HOST"],
        "dbname" => $_ENV["DB_NAME"],
        "username" => $_ENV["DB_USER"],
        "password" => $_ENV["DB_PASSWORD"],
        "port" => $_ENV["DB_PORT"]
    ])
];
