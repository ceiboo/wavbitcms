<?php

namespace Guaroj;

use PDO;
use Error;
use Illuminate\Database\Capsule\Manager as Capsule;


class DB
{
    protected static $instance;
    protected $capsule;

    public function __construct(private array $dbConnection)
    {
        $this->doConnection();
    }

    public static function getInstance()
    {
        if (is_null(static::$instance)) {
            static::$instance = Container::getInstance()->get(DB::class);
        }

        return static::$instance;
    }

    public function getConnection() {
        return $this->capsule;
    }

    public function doConnection()
    {
        $this->capsule = new Capsule;
        $this->capsule->addConnection([
        "driver" => $this->dbConnection["driver"],
        "host" =>$this->dbConnection["host"],
        "database" => $this->dbConnection["dbname"],
        "username" => $this->dbConnection["username"],
        "password" => $this->dbConnection["password"]
        ]);
        $this->capsule->setAsGlobal();
        $this->capsule->bootEloquent();
    }


}
