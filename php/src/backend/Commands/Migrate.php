<?php

namespace Backend\Commands;

use Faker\Factory as Faker;
use Guaroj\Migration;
use Guaroj\DB;
use Ramsey\Uuid\Uuid;

class Migrate extends Migration
{
    protected $db;

    public function __construct()
    {
        parent::__construct();
        $this->db = DB::getInstance()->getConnection();
    }

    public function run()
    {
        $this->processMigration();
        $this->processSeeder();
    }


}
