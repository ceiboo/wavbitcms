<?php

namespace Backend\Commands;

use Guaroj\Command;
use Guaroj\Response;
use Backend\Models\User;

class GetUsers
{
    //protected $db;
    protected $response;

    public function __construct()
    {
       // $this->db = DB::getInstance()->getConnection();
        $this->response = Response::getInstance();
    }

    public function run()
    {
        $users = User::orderBy('UserID', 'ASC')->get()->toArray();
        $this->response->execute($users);
        
    }


}
